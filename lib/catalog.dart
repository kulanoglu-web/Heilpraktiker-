import 'package:flutter/material.dart';

import 'catalog_models.dart';
import 'learn.dart';
import 'models.dart';
import 'quiz.dart';
import 'theme.dart';

class CatalogScreen extends StatefulWidget {
  final ExamProfile profile;
  final Future<LearningCatalog>? catalog;
  const CatalogScreen({super.key, required this.profile, this.catalog});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<LearningCatalog> loading;
  Set<String> known = {};

  @override
  void initState() {
    super.initState();
    loading = widget.catalog ?? loadLearningCatalog();
    _refresh();
  }

  Future<void> _refresh() async {
    final ids = await Progress.ids(Progress.knownKey);
    if (mounted) setState(() => known = ids);
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    await _refresh();
  }

  Widget _link(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback tap,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: SoftCard(
      onTap: tap,
      child: Row(
        children: [
          Icon(icon, color: kAccent, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: plainAppBar('Lernkatalog'),
    body: FutureBuilder<LearningCatalog>(
      future: loading,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Der Lernkatalog konnte nicht geladen werden.'),
                TextButton(
                  onPressed: () =>
                      setState(() => loading = loadLearningCatalog()),
                  child: const Text('Erneut versuchen'),
                ),
              ],
            ),
          );
        }
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final c = snapshot.data!;
        final learned = c.cards.where((card) => known.contains(card.id)).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            SoftCard(
              gradient: brandGradient(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${c.totalQuestionCount} Fragen mit Antworten',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.introduction,
                    style: const TextStyle(color: Colors.white, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$learned von ${c.cards.length} Wissensfragen gelernt',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: c.cards.isEmpty ? 0 : learned / c.cards.length,
                    color: kAccent,
                    backgroundColor: Colors.white24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _link(
              Icons.travel_explore_rounded,
              'Prüfungsrahmen & Bundesländer',
              'Alle 16 Länder · dein Profil: ${widget.profile.name}',
              () => _open(
                CatalogRegionsScreen(catalog: c, selectedId: widget.profile.id),
              ),
            ),
            _link(
              Icons.search_rounded,
              'Alle Wissensfragen durchsuchen',
              '${c.cards.length} Fragen · Antworten aufdecken und Lernstand speichern',
              () => _open(
                CatalogStudyScreen(title: 'Wissensfragen', cards: c.cards),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Nach Kapiteln lernen',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
            ),
            for (final chapter in c.chapters)
              _link(
                Icons.menu_book_rounded,
                chapter.title,
                '${chapter.cards.where((card) => known.contains(card.id)).length} von ${chapter.cards.length} gelernt',
                () => _open(
                  CatalogStudyScreen(
                    title: chapter.title,
                    cards: chapter.cards,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            _link(
              Icons.record_voice_over_rounded,
              'Mündliche Fallübungen',
              '${c.oralCases.length} Fälle · laut antworten und vergleichen',
              () => _open(
                OralListScreen(cases: c.oralCases, profile: widget.profile),
              ),
            ),
            _link(
              Icons.timer_outlined,
              'Probeprüfung · 28 Fragen',
              '60 Minuten · mindestens 21 richtig · Lösungen am Ende',
              () => _open(
                QuizScreen(
                  profile: catalogExamProfile,
                  questions: c.examQuestions,
                  examMode: true,
                  title: 'Probeprüfung',
                ),
              ),
            ),
            _link(
              Icons.fact_check_outlined,
              'Lösungen & Erklärungen',
              'Alle 28 Auswahlfragen mit aufdeckbarer Lösung',
              () => _open(CatalogSolutionsScreen(questions: c.examQuestions)),
            ),
            if (c.extraQuestions.isNotEmpty)
              _link(
                Icons.auto_stories_rounded,
                'Vertiefung · ${c.extraQuestions.length} Fragen',
                'Zusätzliche Übungen nach Themen · mit Lösungen',
                () => _open(
                  CatalogPracticeScreen(
                    questions: c.extraQuestions,
                    profile: widget.profile,
                  ),
                ),
              ),

          ],
        );
      },
    ),
  );
}

class CatalogStudyScreen extends StatefulWidget {
  final String title;
  final List<Flashcard> cards;
  const CatalogStudyScreen({
    super.key,
    required this.title,
    required this.cards,
  });

  @override
  State<CatalogStudyScreen> createState() => _CatalogStudyScreenState();
}

class _CatalogStudyScreenState extends State<CatalogStudyScreen> {
  final search = TextEditingController();
  final shown = <String>{};
  Set<String> known = {};
  bool onlyOpen = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final ids = await Progress.ids(Progress.knownKey);
    if (mounted) setState(() => known = ids);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> _mark(String id, bool value) async {
    if (saving) return;
    setState(() => saving = true);
    try {
      if (value) {
        await Progress.addAll(Progress.knownKey, [id]);
      } else {
        await Progress.removeAll(Progress.knownKey, [id]);
      }
      await _refresh();
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = search.text.trim().toLowerCase();
    final cards = widget.cards
        .where(
          (c) =>
              (!onlyOpen || !known.contains(c.id)) &&
              (query.isEmpty ||
                  '${c.front} ${c.back} ${c.topic}'.toLowerCase().contains(
                    query,
                  )),
        )
        .toList();
    return Scaffold(
      appBar: plainAppBar(widget.title),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Frage oder Antwort suchen',
                    prefixIcon: Icon(Icons.search_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilterChip(
                      label: const Text('Nur offene Fragen'),
                      selected: onlyOpen,
                      onSelected: (v) => setState(() => onlyOpen = v),
                    ),
                    Text('${cards.length} Fragen'),
                    TextButton.icon(
                      onPressed: cards.isEmpty
                          ? null
                          : () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FlashcardScreen(cards: cards),
                                ),
                              );
                              await _refresh();
                            },
                      icon: const Icon(Icons.style_rounded),
                      label: const Text('Als Lernkarten'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: cards.isEmpty
                ? const Center(child: Text('Keine passenden offenen Fragen.'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final visible = shown.contains(card.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SoftCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.front,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => setState(() {
                                  visible
                                      ? shown.remove(card.id)
                                      : shown.add(card.id);
                                }),
                                icon: Icon(
                                  visible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                label: Text(
                                  visible
                                      ? 'Antwort verbergen'
                                      : 'Antwort zeigen',
                                ),
                              ),
                              if (visible) ...[
                                SelectableText(
                                  card.back,
                                  style: const TextStyle(height: 1.5),
                                ),
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Gelernt'),
                                  value: known.contains(card.id),
                                  onChanged: saving
                                      ? null
                                      : (v) => _mark(card.id, v == true),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ] else if (known.contains(card.id))
                                const Text(
                                  'Bereits gelernt',
                                  style: TextStyle(color: kGood),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CatalogSolutionsScreen extends StatelessWidget {
  final List<Question> questions;
  const CatalogSolutionsScreen({super.key, required this.questions});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: plainAppBar('Lösungen & Erklärungen'),
    body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length,
      itemBuilder: (context, i) {
        final q = questions[i];
        return Card(
          child: ExpansionTile(
            title: Text('${i + 1}. ${q.text}'),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final correct in q.correctSet)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '✓ ${q.options[correct]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: kGood,
                    ),
                  ),
                ),
              Text(q.explanation, style: const TextStyle(height: 1.5)),
            ],
          ),
        );
      },
    ),
  );
}

class CatalogRegionsScreen extends StatelessWidget {
  final LearningCatalog catalog;
  final String selectedId;
  const CatalogRegionsScreen({
    super.key,
    required this.catalog,
    required this.selectedId,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: plainAppBar('Prüfungsrahmen & Bundesländer'),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SoftCard(
          child: Text(catalog.framework, style: const TextStyle(height: 1.5)),
        ),
        const SizedBox(height: 12),
        const Text(
          'Die Fallübungen dienen dem Training. Verbindliche Prüfungsregeln und Zuständigkeiten können sich örtlich unterscheiden.',
          style: TextStyle(height: 1.4),
        ),
        const SizedBox(height: 12),
        for (final r in catalog.regions)
          Card(
            child: ExpansionTile(
              initiallyExpanded: r.id == selectedId,
              title: Text(r.name),
              subtitle: Text(r.oralCase == null ? 'Allgemeine Vorbereitung' : 'Fallübung verfügbar'),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.topic),
                if (r.oralCase != null)
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OralCaseScreen(oralCase: r.oralCase!),
                      ),
                    ),
                    icon: const Icon(Icons.record_voice_over_rounded),
                    label: const Text('Fallübung öffnen'),
                  ),

              ],
            ),
          ),
      ],
    ),
  );
}

class CatalogPracticeScreen extends StatefulWidget {
  final List<Question> questions;
  final ExamProfile profile;
  const CatalogPracticeScreen({
    super.key,
    required this.questions,
    required this.profile,
  });

  @override
  State<CatalogPracticeScreen> createState() => _CatalogPracticeScreenState();
}

class _CatalogPracticeScreenState extends State<CatalogPracticeScreen> {
  String? topic;
  String query = '';

  List<Question> get filtered => widget.questions
      .where(
        (q) =>
            (topic == null || q.topic == topic) &&
            '${q.text} ${q.explanation} ${q.options.join(' ')}'
                .toLowerCase()
                .contains(query.trim().toLowerCase()),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final questions = filtered;
    final topics = widget.questions.map((q) => q.topic).toSet().toList()
      ..sort();
    return Scaffold(
      appBar: plainAppBar('Vertiefung'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${widget.questions.length} zusätzliche Übungsfragen',
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thema wählen oder nach Begriffen suchen. Im Übungsmodus wird jede Antwort erklärt.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: topic ?? '',
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Thema',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: '', child: Text('Alle Themen')),
              for (final t in topics)
                DropdownMenuItem(value: t, child: Text(t)),
            ],
            onChanged: (value) =>
                setState(() => topic = value == '' ? null : value),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              labelText: 'Begriff suchen',
              prefixIcon: Icon(Icons.search_rounded),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text('${questions.length} passende Fragen'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: questions.isEmpty
                ? null
                : () {
                    final picked = List<Question>.of(questions)..shuffle();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          profile: widget.profile,
                          questions: picked.take(20).toList(),
                          examMode: false,
                          title: 'Vertiefung',
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.school_rounded),
            label: const Text('Bis zu 20 Fragen üben'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: questions.isEmpty
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          CatalogSolutionsScreen(questions: questions),
                    ),
                  ),
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('Alle passenden Fragen durchgehen'),
          ),
          if (questions.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Keine Treffer. Ändere den Suchbegriff oder das Thema.',
              ),
            ),
        ],
      ),
    );
  }
}
