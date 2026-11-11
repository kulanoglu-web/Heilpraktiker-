import 'dart:convert';

import 'package:flutter/services.dart';

import 'models.dart';

/// The fixed practice paper has its own rules, independent of state selection.
const catalogExamProfile = ExamProfile(
  id: 'catalog',
  name: 'Lernkatalog · Probeprüfung',
  questionCount: 28,
  passRatio: 0.75,
  minutes: 60,
  note: '28 Fragen, 60 Minuten, mindestens 21 vollständig richtige Antworten.',
);

class CatalogChapter {
  final String id;
  final String title;
  final List<Flashcard> cards;
  const CatalogChapter(this.id, this.title, this.cards);
}

class CatalogRegion {
  final String id;
  final String name;
  final String location;
  final String topic;
  final String url;
  final OralCase? oralCase;
  const CatalogRegion({
    required this.id,
    required this.name,
    required this.location,
    required this.topic,
    required this.url,
    this.oralCase,
  });
}

class CatalogSource {
  final String title;
  final String url;
  final String note;
  const CatalogSource(this.title, this.url, this.note);
}

class LearningCatalog {
  final String title;
  final String date;
  final String introduction;
  final String framework;
  final String note;
  final List<CatalogChapter> chapters;
  final List<OralCase> oralCases;
  final List<Question> examQuestions;
  final List<Question> extraQuestions;
  final List<CatalogRegion> regions;
  final List<CatalogSource> sources;

  const LearningCatalog({
    required this.title,
    required this.date,
    required this.introduction,
    required this.framework,
    required this.note,
    required this.chapters,
    required this.oralCases,
    required this.examQuestions,
    required this.extraQuestions,
    required this.regions,
    required this.sources,
  });

  List<Flashcard> get cards => chapters.expand((c) => c.cards).toList();
  int get totalQuestionCount => questionCount + extraQuestions.length;
  int get questionCount =>
      cards.length +
      oralCases.fold<int>(0, (n, c) => n + c.questions.length) +
      examQuestions.length;

  factory LearningCatalog.fromJson(
    Map<String, dynamic> json, {
    required List<Flashcard> cards,
    required List<OralCase> cases,
    required List<Question> questions,
  }) {
    final byCard = {for (final c in cards) c.id: c};
    final byCase = {for (final c in cases) c.id: c};
    final byQuestion = {for (final q in questions) q.id: q};
    T resolve<T>(Map<String, T> map, dynamic id) {
      final value = map[id];
      if (value == null) throw FormatException('Fehlender Katalogeintrag: $id');
      return value;
    }

    final result = LearningCatalog(
      title: json['title'] as String,
      date: json['date'] as String,
      introduction: json['introduction'] as String,
      framework: json['framework'] as String,
      note: json['note'] as String,
      chapters: [
        for (final c in json['chapters'] as List)
          CatalogChapter(c['id'] as String, c['title'] as String, [
            for (final id in c['cardIds'] as List) resolve(byCard, id),
          ]),
      ],
      oralCases: [
        for (final id in json['oralCaseIds'] as List) resolve(byCase, id),
      ],
      examQuestions: [
        for (final id in json['examQuestionIds'] as List)
          resolve(byQuestion, id),
      ],
      extraQuestions: [
        for (final id in (json['extraQuestionIds'] as List? ?? []))
          resolve(byQuestion, id),
      ],
      regions: [
        for (final r in json['regions'] as List)
          CatalogRegion(
            id: r['id'] as String,
            name: r['name'] as String,
            location: r['location'] as String,
            topic: r['topic'] as String,
            url: r['url'] as String,
            oralCase: r['caseId'] == null ? null : resolve(byCase, r['caseId']),
          ),
      ],
      sources: [
        for (final s in json['sources'] as List)
          CatalogSource(
            s['title'] as String,
            s['url'] as String,
            s['note'] as String,
          ),
      ],
    );
    if (result.questionCount != json['totalQuestions'] ||
        result.examQuestions.length != catalogExamProfile.questionCount) {
      throw const FormatException('Unvollständiger Lernkatalog');
    }
    return result;
  }
}

Future<LearningCatalog> loadLearningCatalog() async {
  final data = await Future.wait<dynamic>([
    rootBundle.loadString('assets/data/learning_catalog.json'),
    loadFlashcards(),
    loadOralCases(),
    loadQuestions(),
  ]);
  return LearningCatalog.fromJson(
    jsonDecode(data[0] as String) as Map<String, dynamic>,
    cards: data[1] as List<Flashcard>,
    cases: data[2] as List<OralCase>,
    questions: data[3] as List<Question>,
  );
}
