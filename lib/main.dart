import 'package:flutter/material.dart';

import 'info.dart';
import 'learn.dart';
import 'models.dart';
import 'quiz.dart';
import 'theme.dart';

void main() => runApp(const HpApp());

class HpApp extends StatelessWidget {
  const HpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HP Psychotherapie Trainer',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
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
  Map<String, List<int>> stats = {};
  int wrongCount = 0;
  int knownCards = 0;
  int totalCards = 0;
  int totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final h = await Progress.history();
    final s = await Progress.topicStats();
    final w = await Progress.ids(Progress.wrongKey);
    final k = await Progress.ids(Progress.knownKey);
    final cards = await loadFlashcards();
    final qs = await loadQuestions();
    if (!mounted) return;
    setState(() {
      history = h;
      stats = s;
      wrongCount = w.length;
      knownCards = k.length;
      totalCards = cards.length;
      totalQuestions = qs.length;
    });
  }

  double get accuracy {
    var r = 0;
    var t = 0;
    for (final v in stats.values) {
      r += v[0];
      t += v[1];
    }
    return t == 0 ? 0 : r / t;
  }

  int get answered => stats.values.fold<int>(0, (a, v) => a + v[1]);

  /// Prüfungsnaher Fragensatz: Themenmix wie in der Prüfung.
  Future<void> _startExam() async {
    final all = await loadQuestions();
    final wrong = await Progress.ids(Progress.wrongKey);
    final set = buildExamSet(all, profile.questionCount, wrongIds: wrong);
    await _openQuiz(set, true, 'Prüfungssimulation');
  }

  Future<void> _startPractice([String? topic]) async {
    final all = await loadQuestions();
    final list = all.where((q) => topic == null || q.topic == topic).toList()
      ..shuffle();
    await _openQuiz(list, false, topic ?? 'Übungsmodus');
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
    await _openQuiz(wrong, false, 'Fehler wiederholen');
  }

  Future<void> _openQuiz(List<Question> qs, bool examMode, String title) async {
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => QuizScreen(
        profile: profile,
        questions: qs,
        examMode: examMode,
        title: examMode ? '' : title,
      ),
    ));
    _refresh();
  }

  Future<void> _openCards([String? topic]) async {
    final cards = await loadFlashcards();
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FlashcardScreen(cards: cards, initialTopic: topic),
    ));
    _refresh();
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
    final topics = examTopicWeights.keys.toList();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _hero(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileCard(context),
                  const SizedBox(height: 18),
                  _examTile(context),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.12,
                    children: [
                      _modeTile(Icons.school_rounded, 'Übungsmodus',
                          'Sofort erklärt', const Color(0xFF2F7DB5), _startPractice),
                      _modeTile(
                          Icons.replay_rounded,
                          'Fehler wiederholen',
                          wrongCount == 0
                              ? 'Noch keine Fehler'
                              : '$wrongCount offen',
                          const Color(0xFFE0603A),
                          _startRepeatWrong),
                      _modeTile(
                          Icons.style_rounded,
                          'Kernkarten',
                          '$knownCards von $totalCards gewusst',
                          const Color(0xFF7E57C2),
                          _openCards),
                      _modeTile(
                          Icons.record_voice_over_rounded,
                          'Mündliche Prüfung',
                          'Fälle & Musterantworten',
                          kAccent,
                          _openOral),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(context, 'Nach Thema üben'),
                  const SizedBox(height: 4),
                  Text('Tippen = Fragen, langes Drücken = Kernkarten',
                      style: TextStyle(
                          fontSize: 12.5,
                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in topics) _topicButton(t),
                    ],
                  ),
                  if (stats.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _sectionTitle(context, 'Dein Lernstand'),
                    const SizedBox(height: 8),
                    SoftCard(
                      child: Column(
                        children: [
                          for (final t in topics)
                            if (stats[t] != null && stats[t]![1] > 0)
                              BarRow(
                                label: t,
                                value: stats[t]![0] / stats[t]![1],
                                color: topicStyle(t).color,
                                trailing:
                                    '${(stats[t]![0] * 100 / stats[t]![1]).round()} %',
                              ),
                        ],
                      ),
                    ),
                  ],
                  if (history.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _sectionTitle(context, 'Letzte Prüfungssimulationen'),
                    const SizedBox(height: 8),
                    for (final h in history.take(5)) _historyRow(context, h),
                  ],
                  const SizedBox(height: 24),
                  const InfoCard(),
                  const SizedBox(height: 16),
                  Text(
                    'Lernhilfe: Alle Fragen, Karten und Fälle sind eigene '
                    'Formulierungen und keine Original-Prüfungsfragen. '
                    'Alles ohne Gewähr. Verbindliche Regeln gibt das zuständige Gesundheitsamt.',
                    style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2A45), Color(0xFF2F5D8A), Color(0xFF19A7A0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
              color: tint(const Color(0xFF0F2A45), 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology_rounded,
                            color: Colors.white, size: 26),
                        const SizedBox(width: 8),
                        Text('HP Psychotherapie',
                            style: TextStyle(
                                color: tint(Colors.white, 0.9),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Bereit für\ndie Prüfung?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            height: 1.1,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _pill(Icons.quiz_rounded, '$totalQuestions Fragen'),
                        _pill(Icons.style_rounded, '$totalCards Karten'),
                        _pill(Icons.check_circle_outline_rounded,
                            '$answered beantwortet'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ScoreRing(
                value: accuracy,
                size: 104,
                stroke: 11,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${(accuracy * 100).round()}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    const Text('Trefferquote',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: tint(Colors.white, 0.16),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _profileCard(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<ExamProfile>(
            initialValue: profile,
            decoration: InputDecoration(
              labelText: 'Prüfungsprofil (Bundesland)',
              prefixIcon: const Icon(Icons.location_on_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            items: [
              for (final p in examProfiles)
                DropdownMenuItem(value: p, child: Text(p.name)),
            ],
            onChanged: (p) => setState(() => profile = p ?? profile),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _infoChip(Icons.help_outline_rounded,
                  '${profile.questionCount} Fragen'),
              _infoChip(Icons.timer_outlined, '${profile.minutes} Min.'),
              _infoChip(Icons.flag_rounded,
                  '${profile.passCount} richtig zum Bestehen'),
            ],
          ),
          const SizedBox(height: 8),
          Text(profile.note,
              style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    final c = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tint(c, 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: c),
          const SizedBox(width: 5),
          Text(text,
              style: TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w700, color: c)),
        ],
      ),
    );
  }

  Widget _examTile(BuildContext context) {
    return SoftCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF16324F), Color(0xFF2F5D8A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(20),
      onTap: _startExam,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: tint(Colors.white, 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.timer_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prüfungssimulation',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text(
                    'Themenmix nach Prüfungsrelevanz, Zeitlimit und '
                    'Bepunktung. Auswertung mit Erklärung jeder falschen Antwort.',
                    style: TextStyle(color: Colors.white70, height: 1.35)),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill_rounded,
              color: Colors.white, size: 34),
        ],
      ),
    );
  }

  Widget _modeTile(IconData icon, String title, String sub, Color color,
      VoidCallback onTap) {
    return SoftCard(
      gradient: colorGradient(color),
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: tint(Colors.white, 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topicButton(String t) {
    final st = stats[t];
    final suffix =
        st == null || st[1] == 0 ? null : '${(st[0] * 100 / st[1]).round()} %';
    return GestureDetector(
      onLongPress: () => _openCards(t),
      child: TopicChip(
        topic: t,
        selected: false,
        suffix: suffix,
        onTap: () => _startPractice(t),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) => Text(text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w800));

  Widget _historyRow(BuildContext context, String entry) {
    final parts = entry.split('|');
    if (parts.length < 4) return const SizedBox.shrink();
    final score = int.tryParse(parts[2]) ?? 0;
    final total = int.tryParse(parts[3]) ?? 1;
    final passed = score >= (total * profile.passRatio).ceil();
    final c = passed ? kGood : kBad;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: c),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                  '${parts[0].replaceFirst('T', ' ')}  ·  ${parts[1]}',
                  style: const TextStyle(fontSize: 13)),
            ),
            Text('$score/$total',
                style: TextStyle(fontWeight: FontWeight.w800, color: c)),
          ],
        ),
      ),
    );
  }
}
