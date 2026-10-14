import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';

String _letters(Iterable<int> idx) =>
    (idx.toList()..sort()).map((i) => String.fromCharCode(65 + i)).join(', ');

/// Fragen beantworten: Prüfungsmodus (Timer, Auswertung am Ende) oder
/// Übungsmodus (Erklärung nach jeder Antwort). Unterstützt Einfachauswahl,
/// Aussagenkombination und Mehrfachauswahl (mehrere richtige Antworten).
class QuizScreen extends StatefulWidget {
  final ExamProfile profile;
  final List<Question> questions;
  final bool examMode;

  const QuizScreen({
    super.key,
    required this.profile,
    required this.questions,
    required this.examMode,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int index = 0;
  final Map<int, Set<int>> answers = {};
  bool revealed = false;
  late int remaining;
  Timer? timer;

  Question get q => widget.questions[index];
  Set<int> get chosen => answers[index] ?? <int>{};
  bool get selectionComplete => chosen.length == q.correctSet.length;

  @override
  void initState() {
    super.initState();
    remaining = widget.profile.minutes * 60;
    if (widget.examMode) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => remaining--);
        if (remaining <= 0) finish();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void select(int option) {
    if (revealed) return;
    setState(() {
      final s = Set<int>.of(chosen);
      if (q.isMulti) {
        if (s.contains(option)) {
          s.remove(option);
        } else if (s.length < q.correctSet.length) {
          s.add(option);
        }
      } else {
        s
          ..clear()
          ..add(option);
        if (!widget.examMode) revealed = true;
      }
      answers[index] = s;
    });
  }

  void primaryAction() {
    if (!widget.examMode && q.isMulti && !revealed) {
      setState(() => revealed = true);
      return;
    }
    if (index < widget.questions.length - 1) {
      setState(() {
        index++;
        revealed = false;
      });
    } else {
      finish();
    }
  }

  Future<void> finish() async {
    timer?.cancel();
    final wrong = <String>[];
    final right = <String>[];
    for (var i = 0; i < widget.questions.length; i++) {
      final item = widget.questions[i];
      if (item.isCorrect(answers[i] ?? <int>{})) {
        right.add(item.id);
      } else {
        wrong.add(item.id);
      }
    }
    await Progress.addAll(Progress.wrongKey, wrong);
    await Progress.removeAll(Progress.wrongKey, right);
    if (widget.examMode) {
      await Progress.addHistory(
          '${DateTime.now().toIso8601String().substring(0, 16)}|'
          '${widget.profile.name}|${right.length}|${widget.questions.length}');
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => ResultScreen(
        profile: widget.profile,
        questions: widget.questions,
        answers: answers,
      ),
    ));
  }

  String get clock {
    final m = (remaining ~/ 60).toString().padLeft(2, '0');
    final s = (remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ok = q.isCorrect(chosen);
    final last = index == widget.questions.length - 1;
    final needsCheck = !widget.examMode && q.isMulti && !revealed;
    final buttonLabel = needsCheck ? 'Prüfen' : (last ? 'Auswerten' : 'Weiter');
    final buttonEnabled = selectionComplete;

    return Scaffold(
      appBar: AppBar(
        title: Text('Frage ${index + 1} / ${widget.questions.length}'),
        actions: [
          if (widget.examMode)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(clock,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: remaining < 300 ? scheme.error : null)),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${q.topic} · ${q.typeLabel}',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(q.text, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          for (var i = 0; i < q.options.length; i++) _optionTile(i, scheme),
          if (revealed) ...[
            const SizedBox(height: 12),
            Card(
              color: ok ? scheme.primaryContainer : scheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ok ? 'Richtig!' : 'Nicht ganz.',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Richtig: ${_letters(q.correctSet)}'),
                    const SizedBox(height: 6),
                    Text(q.explanation),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: buttonEnabled ? primaryAction : null,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(int i, ColorScheme scheme) {
    Color? color;
    if (revealed) {
      if (q.correctSet.contains(i)) {
        color = scheme.primaryContainer;
      } else if (chosen.contains(i)) {
        color = scheme.errorContainer;
      }
    } else if (chosen.contains(i)) {
      color = scheme.secondaryContainer;
    }
    return Card(
      color: color,
      child: ListTile(
        leading: CircleAvatar(
          radius: 14,
          child: Text(String.fromCharCode(65 + i)),
        ),
        title: Text(q.options[i]),
        trailing: q.isMulti
            ? Icon(chosen.contains(i)
                ? Icons.check_box
                : Icons.check_box_outline_blank)
            : null,
        onTap: () => select(i),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final ExamProfile profile;
  final List<Question> questions;
  final Map<int, Set<int>> answers;

  const ResultScreen({
    super.key,
    required this.profile,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    var score = 0;
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].isCorrect(answers[i] ?? <int>{})) score++;
    }
    final total = questions.length;
    final needed = (total * profile.passRatio).ceil();
    final passed = score >= needed;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ergebnis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: passed ? scheme.primaryContainer : scheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('$score / $total Punkte',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(passed
                      ? 'Bestanden (nötig: $needed)'
                      : 'Noch nicht bestanden (nötig: $needed)'),
                  Text('Profil: ${profile.name}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Auswertung', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var i = 0; i < total; i++) _reviewTile(i),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zurück zum Start'),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(int i) {
    final q = questions[i];
    final given = answers[i] ?? <int>{};
    final ok = q.isCorrect(given);
    return Card(
      child: ExpansionTile(
        leading: Icon(ok ? Icons.check_circle : Icons.cancel,
            color: ok ? Colors.green : Colors.red),
        title: Text('${i + 1}. ${q.text}',
            maxLines: 2, overflow: TextOverflow.ellipsis),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(given.isEmpty
              ? 'Deine Antwort: keine'
              : 'Deine Antwort: ${_letters(given)}'),
          const SizedBox(height: 4),
          Text('Richtig: ${_letters(q.correctSet)}'),
          const SizedBox(height: 8),
          for (var k = 0; k < q.options.length; k++)
            Text('${String.fromCharCode(65 + k)}) ${q.options[k]}'),
          const SizedBox(height: 8),
          Text(q.explanation),
        ],
      ),
    );
  }
}
