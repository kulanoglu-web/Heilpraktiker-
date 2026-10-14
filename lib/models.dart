import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

/// Prüfungsprofil je Bundesland. Berlin ist die Hauptvorgabe.
class ExamProfile {
  final String id;
  final String name;
  final int questionCount;
  final double passRatio;
  final int minutes;
  final int? oralMinutes;
  final String note;

  const ExamProfile({
    required this.id,
    required this.name,
    required this.questionCount,
    required this.passRatio,
    required this.minutes,
    this.oralMinutes,
    required this.note,
  });

  int get passCount => (questionCount * passRatio).ceil();
}

const examProfiles = <ExamProfile>[
  ExamProfile(
    id: 'be',
    name: 'Berlin (Standard)',
    questionCount: 28,
    passRatio: 0.75,
    minutes: 55,
    oralMinutes: 60,
    note: 'Berlin: schriftlich 28 Multiple-Choice-Fragen, 75 % nötig; Termine '
        'im März und Oktober. Mündlich in der Regel höchstens 60 Minuten. '
        'Die Dauer des schriftlichen Teils (hier 55 Min., Angabe von '
        'Prüfungsvorbereitern) bitte beim Bezirksamt Tempelhof-Schöneberg '
        'bestätigen.',
  ),
  ExamProfile(
    id: 'hh',
    name: 'Hamburg',
    questionCount: 28,
    passRatio: 0.75,
    minutes: 60,
    oralMinutes: 45,
    note: 'Hamburg: 28 Fragen, 1 Stunde, mündlich höchstens 45 Minuten.',
  ),
  ExamProfile(
    id: 'by',
    name: 'Bayern',
    questionCount: 28,
    passRatio: 0.75,
    minutes: 60,
    oralMinutes: 20,
    note: 'Bayern: 28 Fragen, 60 Minuten, mündlich in der Regel 20 Minuten.',
  ),
  ExamProfile(
    id: 'bw',
    name: 'Baden-Württemberg',
    questionCount: 28,
    passRatio: 0.75,
    minutes: 56,
    note: 'Baden-Württemberg: 28 Fragen, 56 Minuten (je nach Amt auch 60).',
  ),
  ExamProfile(
    id: 'nrw',
    name: 'Nordrhein-Westfalen',
    questionCount: 28,
    passRatio: 0.75,
    minutes: 60,
    note: 'NRW (z. B. Bielefeld): 28 Fragen, 60 Minuten, 21 richtige nötig.',
  ),
];

class Question {
  final String id;
  final String topic;
  final String text;
  final String kind;
  final List<String> options;
  final List<int> correctSet;
  final String explanation;

  const Question({
    required this.id,
    required this.topic,
    required this.text,
    this.kind = '',
    required this.options,
    required this.correctSet,
    required this.explanation,
  });

  bool get isMulti => correctSet.length > 1;

  String get typeLabel {
    if (isMulti) {
      return 'Mehrfachauswahl: ${correctSet.length} Antworten wählen';
    }
    if (kind == 'combo') return 'Aussagenkombination';
    return 'Einfachauswahl';
  }

  bool isCorrect(Set<int> given) =>
      given.length == correctSet.length && given.containsAll(correctSet);

  /// Mischt die Antwortreihenfolge, damit richtige Antworten nicht immer
  /// an derselben Stelle stehen. `correct` darf eine Zahl oder eine Liste sein.
  factory Question.fromJson(Map<String, dynamic> j) {
    final opts = List<String>.from(j['options'] as List);
    final raw = j['correct'];
    final idx = raw is List ? raw.cast<int>() : <int>[raw as int];
    final rights = idx.map((i) => opts[i]).toList();
    opts.shuffle();
    final set = rights.map(opts.indexOf).toList()..sort();
    return Question(
      id: j['id'] as String,
      topic: j['topic'] as String,
      text: j['text'] as String,
      kind: (j['kind'] as String?) ?? '',
      options: opts,
      correctSet: set,
      explanation: j['explanation'] as String,
    );
  }
}

class Flashcard {
  final String id;
  final String topic;
  final String front;
  final String back;

  const Flashcard({
    required this.id,
    required this.topic,
    required this.front,
    required this.back,
  });

  factory Flashcard.fromJson(Map<String, dynamic> j) => Flashcard(
        id: j['id'] as String,
        topic: j['topic'] as String,
        front: j['front'] as String,
        back: j['back'] as String,
      );
}

class OralQuestion {
  final String question;
  final String answer;
  const OralQuestion({required this.question, required this.answer});
}

class OralCase {
  final String id;
  final String title;
  final String vignette;
  final List<OralQuestion> questions;

  const OralCase({
    required this.id,
    required this.title,
    required this.vignette,
    required this.questions,
  });

  factory OralCase.fromJson(Map<String, dynamic> j) => OralCase(
        id: j['id'] as String,
        title: j['title'] as String,
        vignette: j['vignette'] as String,
        questions: (j['questions'] as List)
            .map((e) => OralQuestion(
                  question: (e as Map<String, dynamic>)['q'] as String,
                  answer: e['a'] as String,
                ))
            .toList(),
      );
}

Future<List<T>> _load<T>(
    String file, T Function(Map<String, dynamic>) parse) async {
  final raw = await rootBundle.loadString('assets/data/$file');
  return (jsonDecode(raw) as List)
      .map((e) => parse(e as Map<String, dynamic>))
      .toList();
}

Future<List<Question>> loadQuestions() =>
    _load('questions.json', Question.fromJson);
Future<List<Flashcard>> loadFlashcards() =>
    _load('flashcards.json', Flashcard.fromJson);
Future<List<OralCase>> loadOralCases() =>
    _load('oral_cases.json', OralCase.fromJson);

/// Lokaler Lernfortschritt (nur auf dem Gerät gespeichert).
class Progress {
  static const wrongKey = 'wrong_question_ids';
  static const knownKey = 'known_flashcard_ids';
  static const historyKey = 'exam_history';
  static const statsKey = 'topic_stats';

  static Future<Set<String>> ids(String key) async {
    final p = await SharedPreferences.getInstance();
    return (p.getStringList(key) ?? <String>[]).toSet();
  }

  static Future<void> _save(String key, Set<String> value) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(key, value.toList());
  }

  static Future<void> addAll(String key, Iterable<String> add) async {
    final s = await ids(key);
    s.addAll(add);
    await _save(key, s);
  }

  static Future<void> removeAll(String key, Iterable<String> remove) async {
    final s = await ids(key);
    s.removeAll(remove);
    await _save(key, s);
  }

  static Future<void> addHistory(String entry) async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(historyKey) ?? <String>[];
    list.insert(0, entry);
    await p.setStringList(historyKey, list.take(30).toList());
  }

  static Future<List<String>> history() async {
    final p = await SharedPreferences.getInstance();
    return p.getStringList(historyKey) ?? <String>[];
  }
  /// Je Themenbereich: [richtig, gesamt] über alle bisher beantworteten Fragen.
  static Future<Map<String, List<int>>> topicStats() async {
    final p = await SharedPreferences.getInstance();
    final m = <String, List<int>>{};
    for (final s in p.getStringList(statsKey) ?? <String>[]) {
      final parts = s.split('|');
      if (parts.length == 3) {
        m[parts[0]] = [int.tryParse(parts[1]) ?? 0, int.tryParse(parts[2]) ?? 0];
      }
    }
    return m;
  }

  static Future<void> recordTopics(Map<String, List<int>> add) async {
    final cur = await topicStats();
    add.forEach((topic, v) {
      final c = cur.putIfAbsent(topic, () => [0, 0]);
      c[0] += v[0];
      c[1] += v[1];
    });
    final p = await SharedPreferences.getInstance();
    await p.setStringList(statsKey,
        cur.entries.map((e) => '${e.key}|${e.value[0]}|${e.value[1]}').toList());
  }
}

/// Gewichtung der Themenbereiche in der schriftlichen Prüfung (Summe 28).
/// Schwerpunkte: Diagnosen nach ICD-10 (v. a. affektive, Angst-, psychotische
/// Störungen), Therapie/Pharmakologie sowie Recht und Berufskunde.
const examTopicWeights = <String, int>{
  'Affekt & Angst': 5,
  'Diagnostik & Therapie': 4,
  'Recht & Praxis': 4,
  'Psychosen': 3,
  'Sucht': 2,
  'Persönlichkeit': 2,
  'Somatoform & Dissoziativ': 2,
  'Essstörungen': 1,
  'Trauma & Belastung': 1,
  'Organisch': 1,
  'Kinder & Jugend': 1,
  'Grundlagen': 1,
  'Weitere Störungen': 1,
};

/// Stellt einen prüfungsnahen Fragensatz zusammen: Themenmix nach
/// [examTopicWeights], Fragen aus Themen mit offenen Fehlern bevorzugt,
/// und eine Mischung aus Einfachauswahl, Aussagenkombination und
/// Mehrfachauswahl.
List<Question> buildExamSet(List<Question> all, int count,
    {Set<String> wrongIds = const {}}) {
  final total = examTopicWeights.values.fold<int>(0, (a, b) => a + b);
  final picked = <Question>[];
  final used = <String>{};
  final byTopic = <String, List<Question>>{};
  for (final q in all) {
    byTopic.putIfAbsent(q.topic, () => []).add(q);
  }
  examTopicWeights.forEach((topic, w) {
    final pool = List<Question>.of(byTopic[topic] ?? <Question>[])..shuffle();
    // bisher falsch beantwortete Fragen zuerst
    pool.sort((a, b) =>
        (wrongIds.contains(b.id) ? 1 : 0) - (wrongIds.contains(a.id) ? 1 : 0));
    final quota = (w * count / total).round().clamp(1, count);
    for (final q in pool.take(quota)) {
      picked.add(q);
      used.add(q.id);
    }
  });
  final rest = all.where((q) => !used.contains(q.id)).toList()..shuffle();
  for (final q in rest) {
    if (picked.length >= count) break;
    picked.add(q);
  }
  picked.shuffle();
  return picked.length > count ? picked.sublist(0, count) : picked;
}
