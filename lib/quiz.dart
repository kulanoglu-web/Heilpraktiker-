import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

String _letters(Iterable<int> idx) =>
    (idx.toList()..sort()).map((i) => String.fromCharCode(65 + i)).join(', ');

/// Fragen beantworten: Prüfungsmodus (Timer, Auswertung am Ende) oder
/// Übungsmodus (Erklärung nach jeder Antwort). Unterstützt Einfachauswahl,
/// Aussagenkombination und Mehrfachauswahl (mehrere richtige Antworten).
class QuizScreen extends StatefulWidget {
  final ExamProfile profile;
  final List<Question> questions;
  final bool examMode;
  final String title;

  const QuizScreen({
    super.key,
    required this.profile,
    required this.questions,
    required this.examMode,
    this.title = '',
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
  bool finished = false;

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

  void previous() {
    if (index == 0) return;
    setState(() {
      index--;
      revealed = !widget.examMode && selectionComplete;
    });
  }

  Future<void> finish() async {
    if (finished) return;
    finished = true;
    timer?.cancel();
    final wrong = <String>[];
    final right = <String>[];
    final topics = <String, List<int>>{};
    for (var i = 0; i < widget.questions.length; i++) {
      final item = widget.questions[i];
      final ok = item.isCorrect(answers[i] ?? <int>{});
      final t = topics.putIfAbsent(item.topic, () => [0, 0]);
      t[1]++;
      if (ok) {
        right.add(item.id);
        t[0]++;
      } else {
        wrong.add(item.id);
      }
    }
    await Progress.addAll(Progress.wrongKey, wrong);
    await Progress.removeAll(Progress.wrongKey, right);
    await Progress.recordTopics(topics);
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
        examMode: widget.examMode,
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
    final last = index == widget.questions.length - 1;
    final needsCheck = !widget.examMode && q.isMulti && !revealed;
    final buttonLabel = needsCheck ? 'Prüfen' : (last ? 'Auswerten' : 'Weiter');
    final style = topicStyle(q.topic);
    final total = widget.questions.length;
    final lowTime = widget.examMode && remaining < 300;

    return Scaffold(
      appBar: plainAppBar(
        widget.title.isEmpty ? 'Frage ${index + 1} von $total' : widget.title,
        actions: [
          if (widget.examMode)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tint(lowTime ? kBad : scheme.primary, 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined,
                      size: 16, color: lowTime ? kBad : scheme.primary),
                  const SizedBox(width: 4),
                  Text(clock,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: lowTime ? kBad : scheme.primary)),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text('${index + 1}/$total',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: (index + 1) / total),
                duration: const Duration(milliseconds: 350),
                builder: (context, v, _) => LinearProgressIndicator(
                  value: v,
                  minHeight: 7,
                  color: style.color,
                  backgroundColor: tint(style.color, 0.15),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0.06, 0), end: Offset.zero)
                      .animate(anim),
                  child: child,
                ),
              ),
              child: ListView(
                key: ValueKey('q$index'),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      TopicChip(topic: q.topic),
                      _TypeBadge(label: q.typeLabel, multi: q.isMulti),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SoftCard(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      q.text,
                      style: const TextStyle(
                          fontSize: 17, height: 1.4, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < q.options.length; i++)
                    _optionTile(i, scheme),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: revealed
                        ? Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: AnswerFeedback(question: q, given: chosen),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  if (widget.examMode && index > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton.outlined(
                        onPressed: previous,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: style.color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: selectionComplete ? primaryAction : null,
                      child: Text(buttonLabel,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(int i, ColorScheme scheme) {
    final isRight = q.correctSet.contains(i);
    final isChosen = chosen.contains(i);
    Color border = isDark(context)
        ? const Color(0xFF263547)
        : const Color(0xFFE3E9F0);
    Color fill = isDark(context) ? const Color(0xFF17222F) : Colors.white;
    Color badge = tint(scheme.primary, 0.12);
    Color badgeText = scheme.primary;
    Widget? trailing;
    if (revealed) {
      if (isRight) {
        border = kGood;
        fill = tint(kGood, 0.12);
        badge = kGood;
        badgeText = Colors.white;
        trailing = const Icon(Icons.check_circle_rounded, color: kGood);
      } else if (isChosen) {
        border = kBad;
        fill = tint(kBad, 0.10);
        badge = kBad;
        badgeText = Colors.white;
        trailing = const Icon(Icons.cancel_rounded, color: kBad);
      }
    } else if (isChosen) {
      border = scheme.primary;
      fill = tint(scheme.primary, 0.10);
      badge = scheme.primary;
      badgeText = Colors.white;
      if (q.isMulti) {
        trailing = Icon(Icons.check_box_rounded, color: scheme.primary);
      }
    } else if (q.isMulti) {
      trailing = Icon(Icons.check_box_outline_blank_rounded,
          color: scheme.outline);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 1.6),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => select(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: badge,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(String.fromCharCode(65 + i),
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: badgeText)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(q.options[i],
                          style: const TextStyle(fontSize: 15, height: 1.35)),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final bool multi;
  const _TypeBadge({required this.label, required this.multi});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: tint(c, 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(multi ? Icons.checklist_rounded : Icons.radio_button_checked,
              size: 14, color: c),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: c)),
        ],
      ),
    );
  }
}

/// Rückmeldung zu einer Antwort. Bei falschen Antworten wird erklärt,
/// welche eigene Auswahl falsch war, was richtig gewesen wäre und warum.
class AnswerFeedback extends StatelessWidget {
  final Question question;
  final Set<int> given;
  const AnswerFeedback({super.key, required this.question, required this.given});

  @override
  Widget build(BuildContext context) {
    final q = question;
    final ok = q.isCorrect(given);
    final color = ok ? kGood : kBad;
    final wrongPicks = (given.toList()..sort())
        .where((i) => !q.correctSet.contains(i))
        .toList();
    final missed = (q.correctSet.toList()..sort())
        .where((i) => !given.contains(i))
        .toList();
    final onSurface = Theme.of(context).colorScheme.onSurface;

    Widget line(IconData icon, Color c, String head, int i) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: c),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: '$head ${String.fromCharCode(65 + i)}: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, color: c)),
                  TextSpan(text: q.options[i]),
                ])),
              ),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tint(color, 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tint(color, 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ok ? Icons.emoji_events_rounded : Icons.lightbulb_rounded,
                  color: color),
              const SizedBox(width: 8),
              Text(
                ok
                    ? 'Richtig!'
                    : (given.isEmpty
                        ? 'Nicht beantwortet'
                        : 'Das war nicht ganz richtig'),
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!ok) ...[
            for (final i in wrongPicks)
              line(Icons.close_rounded, kBad, 'Deine Auswahl', i),
            if (wrongPicks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 26),
                child: Text(
                  wrongPicks.length == 1
                      ? 'Diese Aussage trifft hier nicht zu. Achte auf das '
                          'Schlüsselwort in der Frage und vergleiche mit der '
                          'richtigen Antwort.'
                      : 'Diese Aussagen treffen hier nicht zu.',
                  style: TextStyle(
                      fontSize: 13, color: tint(onSurface, 0.75), height: 1.35),
                ),
              ),
            for (final i in missed)
              line(Icons.check_rounded, kGood, 'Richtig wäre', i),
            if (missed.isNotEmpty) const SizedBox(height: 4),
          ] else
            line(Icons.check_rounded, kGood, 'Richtig', q.correctSet.first),
          if (ok && q.isMulti)
            ...q.correctSet
                .skip(1)
                .map((i) => line(Icons.check_rounded, kGood, 'Richtig', i)),
          const Divider(height: 20),
          Text('Erklärung',
              style: TextStyle(
                  fontSize: 12.5,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w800,
                  color: tint(onSurface, 0.65))),
          const SizedBox(height: 4),
          Text(q.explanation, style: const TextStyle(fontSize: 14.5, height: 1.45)),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final ExamProfile profile;
  final List<Question> questions;
  final Map<int, Set<int>> answers;
  final bool examMode;

  const ResultScreen({
    super.key,
    required this.profile,
    required this.questions,
    required this.answers,
    this.examMode = true,
  });

  @override
  Widget build(BuildContext context) {
    var score = 0;
    final topics = <String, List<int>>{};
    final wrongQs = <Question>[];
    for (var i = 0; i < questions.length; i++) {
      final ok = questions[i].isCorrect(answers[i] ?? <int>{});
      final t = topics.putIfAbsent(questions[i].topic, () => [0, 0]);
      t[1]++;
      if (ok) {
        score++;
        t[0]++;
      } else {
        wrongQs.add(questions[i]);
      }
    }
    final total = questions.length;
    final needed = (total * profile.passRatio).ceil();
    final passed = score >= needed;
    final base = passed ? kGood : const Color(0xFFE0603A);
    final sortedTopics = topics.entries.toList()
      ..sort((a, b) => (a.value[0] / a.value[1])
          .compareTo(b.value[0] / b.value[1]));

    return Scaffold(
      appBar: plainAppBar('Ergebnis'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          SoftCard(
            gradient: colorGradient(base),
            borderColor: Colors.transparent,
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                ScoreRing(
                  value: total == 0 ? 0 : score / total,
                  size: 112,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$score',
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      Text('von $total',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passed ? 'Bestanden!' : 'Noch nicht bestanden',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        examMode
                            ? 'Nötig: $needed richtige Antworten (${(profile.passRatio * 100).round()} %).'
                            : 'Übung – Vergleichswert: $needed von $total.',
                        style: const TextStyle(
                            color: Colors.white, height: 1.35),
                      ),
                      const SizedBox(height: 4),
                      Text(profile.name,
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (wrongQs.isNotEmpty)
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    profile: profile,
                    questions: wrongQs,
                    examMode: false,
                    title: 'Falsche wiederholen',
                  ),
                ),
              ),
              icon: const Icon(Icons.replay_rounded),
              label: Text(
                  '${wrongQs.length} falsche Fragen jetzt wiederholen'),
            ),
          const SizedBox(height: 16),
          Text('Deine Themen',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          SoftCard(
            child: Column(
              children: [
                for (final e in sortedTopics)
                  BarRow(
                    label: e.key,
                    value: e.value[0] / e.value[1],
                    color: topicStyle(e.key).color,
                    trailing: '${e.value[0]}/${e.value[1]}',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Auswertung mit Erklärungen',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (var i = 0; i < total; i++) _reviewTile(context, i),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zurück zum Start'),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(BuildContext context, int i) {
    final q = questions[i];
    final given = answers[i] ?? <int>{};
    final ok = q.isCorrect(given);
    final c = ok ? kGood : kBad;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        padding: EdgeInsets.zero,
        borderColor: tint(c, 0.45),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: c),
            title: Text('${i + 1}. ${q.text}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
            subtitle: Text(q.topic,
                style: TextStyle(fontSize: 12, color: topicStyle(q.topic).color)),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q.text, style: const TextStyle(fontSize: 15, height: 1.4)),
              const SizedBox(height: 10),
              for (var k = 0; k < q.options.length; k++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${String.fromCharCode(65 + k)}) ${q.options[k]}',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: q.correctSet.contains(k) || given.contains(k)
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: q.correctSet.contains(k)
                          ? kGood
                          : (given.contains(k) ? kBad : null),
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                given.isEmpty
                    ? 'Deine Antwort: keine  ·  Richtig: ${_letters(q.correctSet)}'
                    : 'Deine Antwort: ${_letters(given)}  ·  Richtig: ${_letters(q.correctSet)}',
                style: const TextStyle(fontSize: 12.5),
              ),
              const SizedBox(height: 10),
              AnswerFeedback(question: q, given: given),
            ],
          ),
        ),
      ),
    );
  }
}
