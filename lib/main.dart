import 'package:flutter/material.dart';

import 'learn.dart';
import 'models.dart';
import 'quiz.dart';

void main() => runApp(const HpApp());

class HpApp extends StatelessWidget {
  const HpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HP Psychotherapie Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3F6C8C),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ExamProfile profile = examProfiles.first;
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final h = await Progress.history();
    if (mounted) setState(() => history = h);
  }

  Future<void> _startExam({required bool examMode}) async {
    final all = await loadQuestions();
    all.shuffle();
    final count = examMode
        ? (all.length < profile.questionCount
            ? all.length
            : profile.questionCount)
        : all.length;
    await _openQuiz(all.take(count).toList(), examMode);
  }

  Future<void> _startRepeatWrong() async {
    final wrongIds = await Progress.ids(Progress.wrongKey);
    final all = await loadQuestions();
    final wrong = all.where((q) => wrongIds.contains(q.id)).toList()..shuffle();
    if (wrong.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keine falsch beantworteten Fragen.')),
      );
      return;
    }
    await _openQuiz(wrong, false);
  }

  Future<void> _openQuiz(List<Question> qs, bool examMode) async {
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          QuizScreen(profile: profile, questions: qs, examMode: examMode),
    ));
    _loadHistory();
  }

  Future<void> _openCards() async {
    final cards = await loadFlashcards();
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FlashcardScreen(cards: cards),
    ));
  }

  Future<void> _openOral() async {
    final cases = await loadOralCases();
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => OralListScreen(cases: cases, profile: profile),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HP Psychotherapie Trainer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<ExamProfile>(
            initialValue: profile,
            decoration: const InputDecoration(
              labelText: 'Prüfungsprofil (Bundesland)',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final p in examProfiles)
                DropdownMenuItem(value: p, child: Text(p.name)),
            ],
            onChanged: (p) => setState(() => profile = p ?? profile),
          ),
          const SizedBox(height: 8),
          Text(
            '${profile.questionCount} Fragen, ${profile.minutes} Min., '
            '${profile.passCount} richtig zum Bestehen',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(profile.note, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          _tile(Icons.timer, 'Prüfungssimulation',
              'Zeitlimit, Bepunktung, Auswertung am Ende',
              () => _startExam(examMode: true)),
          _tile(Icons.school, 'Übungsmodus',
              'Nach jeder Antwort eine verständliche Erklärung',
              () => _startExam(examMode: false)),
          _tile(Icons.replay, 'Fehler wiederholen',
              'Nur Fragen, die zuletzt falsch waren', _startRepeatWrong),
          _tile(Icons.style, 'Lernkarteien', 'Themenbereiche abfragen',
              _openCards),
          _tile(Icons.record_voice_over, 'Mündliche Prüfung',
              'Fallbeschreibungen mit Fragen und Musterantworten', _openOral),
          if (history.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Letzte Prüfungssimulationen',
                style: Theme.of(context).textTheme.titleSmall),
            for (final h in history.take(5)) _historyRow(h),
          ],
          const SizedBox(height: 24),
          Text(
            'Lernhilfe: Alle Fragen, Karten und Fälle sind eigene Formulierungen '
            'und keine Original-Prüfungsfragen. Verbindliche Regeln gibt das '
            'zuständige Gesundheitsamt.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String sub, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(sub),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _historyRow(String entry) {
    final parts = entry.split('|');
    if (parts.length < 4) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
          '${parts[0].replaceFirst('T', ' ')}  ${parts[1]}: ${parts[2]}/${parts[3]}'),
    );
  }
}
