import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

/// Kernkarten: Lernkarteien nach Themenbereichen mit Umdreh-Animation.
class FlashcardScreen extends StatefulWidget {
  final List<Flashcard> cards;
  final String? initialTopic;
  const FlashcardScreen({super.key, required this.cards, this.initialTopic});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  String? topic;
  late List<Flashcard> deck;
  Set<String> known = {};
  int pos = 0;
  bool flipped = false;
  bool onlyOpen = false;

  @override
  void initState() {
    super.initState();
    topic = widget.initialTopic;
    deck = _buildDeck();
    Progress.ids(Progress.knownKey).then((s) {
      if (mounted) {
        setState(() {
          known = s;
          deck = _buildDeck();
          pos = 0;
        });
      }
    });
  }

  List<Flashcard> _buildDeck() {
    final d = widget.cards
        .where((c) => (topic == null || c.topic == topic) &&
            (!onlyOpen || !known.contains(c.id)))
        .toList()
      ..shuffle();
    return d;
  }

  List<String> get topics =>
      widget.cards.map((c) => c.topic).toSet().toList()..sort();

  void rebuild() {
    setState(() {
      deck = _buildDeck();
      pos = 0;
      flipped = false;
    });
  }

  Future<void> rate(bool knewIt) async {
    if (deck.isEmpty) return;
    final c = deck[pos];
    if (knewIt) {
      known.add(c.id);
      await Progress.addAll(Progress.knownKey, [c.id]);
    } else {
      known.remove(c.id);
      await Progress.removeAll(Progress.knownKey, [c.id]);
    }
    if (!mounted) return;
    setState(() {
      pos = (pos + 1) % deck.length;
      flipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = deck.isEmpty ? null : deck[pos];
    final inScope = widget.cards
        .where((c) => topic == null || c.topic == topic)
        .toList();
    final knownInScope = inScope.where((c) => known.contains(c.id)).length;
    final color = topicStyle(card?.topic ?? topic ?? '').color;

    return Scaffold(
      appBar: plainAppBar('Kernkarten', actions: [
        IconButton(
          tooltip: 'Nur offene Karten',
          onPressed: () {
            onlyOpen = !onlyOpen;
            rebuild();
          },
          icon: Icon(onlyOpen
              ? Icons.filter_alt_rounded
              : Icons.filter_alt_outlined),
        ),
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _allChip(),
                ),
                for (final t in topics)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TopicChip(
                      topic: t,
                      selected: topic == t,
                      onTap: () {
                        topic = t;
                        rebuild();
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: BarRow(
                    label: 'Gewusst',
                    value: inScope.isEmpty ? 0 : knownInScope / inScope.length,
                    color: color,
                    trailing: '$knownInScope von ${inScope.length}',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: card == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Keine offenen Karten in diesem Bereich. Stark!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: GestureDetector(
                      onTap: () => setState(() => flipped = !flipped),
                      onHorizontalDragEnd: (d) {
                        final v = d.primaryVelocity ?? 0;
                        if (v > 300) rate(true);
                        if (v < -300) rate(false);
                      },
                      child: _FlipCard(
                        key: ValueKey(card.id),
                        card: card,
                        flipped: flipped,
                        index: pos + 1,
                        total: deck.length,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              'Tippen zum Umdrehen · nach rechts wischen = gewusst, links = nochmal',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: kBad,
                        side: const BorderSide(color: kBad),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: card == null ? null : () => rate(false),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Nochmal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: kGood,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: card == null ? null : () => rate(true),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Gewusst'),
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

  Widget _allChip() {
    final selected = topic == null;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          topic = null;
          rebuild();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? scheme.primary : tint(scheme.primary, 0.12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text('Alle',
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? scheme.onPrimary : scheme.primary)),
        ),
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  final Flashcard card;
  final bool flipped;
  final int index;
  final int total;
  const _FlipCard({
    super.key,
    required this.card,
    required this.flipped,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final style = topicStyle(card.topic);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: flipped ? math.pi : 0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
      builder: (context, angle, _) {
        final showBack = angle > math.pi / 2;
        final m = Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          ..rotateY(angle);
        return Transform(
          alignment: Alignment.center,
          transform: m,
          child: showBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: _face(context, style, back: true),
                )
              : _face(context, style, back: false),
        );
      },
    );
  }

  Widget _face(BuildContext context, TopicStyle style, {required bool back}) {
    final dark = isDark(context);
    return SizedBox.expand(
      child: SoftCard(
        radius: 28,
        gradient: back
            ? null
            : colorGradient(style.color),
        color: back ? (dark ? const Color(0xFF17222F) : Colors.white) : null,
        borderColor: back ? tint(style.color, 0.5) : Colors.transparent,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: back ? tint(style.color, 0.14) : tint(Colors.white, 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(style.icon,
                      size: 20, color: back ? style.color : Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(card.topic,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: back ? style.color : Colors.white)),
                ),
                Text('$index / $total',
                    style: TextStyle(
                        fontSize: 12.5,
                        color: back
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Colors.white70)),
              ],
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: back
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ANTWORT',
                                style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w800,
                                    color: style.color)),
                            const SizedBox(height: 8),
                            Text(card.back,
                                style:
                                    const TextStyle(fontSize: 17, height: 1.5)),
                          ],
                        )
                      : Text(
                          card.front,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                ),
              ),
            ),
            Icon(back ? Icons.undo_rounded : Icons.touch_app_rounded,
                color: back
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

/// Mündliche Prüfung: Fallbeschreibung, Fragen, Musterantworten.
class OralListScreen extends StatelessWidget {
  final List<OralCase> cases;
  final ExamProfile profile;
  const OralListScreen({super.key, required this.cases, required this.profile});

  @override
  Widget build(BuildContext context) {
    final minutes = profile.oralMinutes;
    return Scaffold(
      appBar: plainAppBar('Mündliche Prüfung'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          SoftCard(
            gradient: brandGradient(),
            borderColor: Colors.transparent,
            child: Row(
              children: [
                const Icon(Icons.record_voice_over_rounded,
                    color: Colors.white, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    minutes == null
                        ? 'Dauer im Profil ${profile.name}: beim Amt erfragen.'
                        : 'Profil ${profile.name}: ca. $minutes Minuten. '
                            'Übe, jeden Fall laut und strukturiert zu besprechen.',
                    style: const TextStyle(color: Colors.white, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < cases.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SoftCard(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OralCaseScreen(oralCase: cases[i]),
                )),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: colorGradient(kAccent),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cases[i].title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('${cases[i].questions.length} Fragen',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OralCaseScreen extends StatefulWidget {
  final OralCase oralCase;
  const OralCaseScreen({super.key, required this.oralCase});

  @override
  State<OralCaseScreen> createState() => _OralCaseScreenState();
}

class _OralCaseScreenState extends State<OralCaseScreen> {
  final Set<int> shown = {};
  final Set<int> rated = {};

  @override
  Widget build(BuildContext context) {
    final c = widget.oralCase;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: plainAppBar(c.title),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          SoftCard(
            gradient: brandGradient(),
            borderColor: Colors.transparent,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assignment_ind_rounded,
                        color: Colors.white70),
                    const SizedBox(width: 8),
                    Text('FALLBESCHREIBUNG',
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800,
                            color: tint(Colors.white, 0.8))),
                  ],
                ),
                const SizedBox(height: 10),
                Text(c.vignette,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15.5, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Beantworte jede Frage zuerst laut in eigenen Worten. Dann die '
            'Musterantwort aufdecken und vergleichen.',
            style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < c.questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: tint(kAccent, 0.15),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  color: kAccent, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(c.questions[i].question,
                              style: const TextStyle(
                                  fontSize: 15.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: shown.contains(i)
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextButton.icon(
                          onPressed: () => setState(() => shown.add(i)),
                          icon: const Icon(Icons.visibility_rounded),
                          label: const Text('Musterantwort zeigen'),
                        ),
                      ),
                      secondChild: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: tint(kAccent, 0.10),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: tint(kAccent, 0.4)),
                        ),
                        child: Text(c.questions[i].answer,
                            style:
                                const TextStyle(fontSize: 14.5, height: 1.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SoftCard(
            borderColor: tint(kAccent, 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fact_check_rounded, color: kAccent),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Selbstbewertung',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                    Text('${rated.length} von 5 Punkten',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: kAccent)),
                  ],
                ),
                const SizedBox(height: 4),
                for (var i = 0; i < _criteria.length; i++)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: rated.contains(i),
                    title: Text(_criteria[i]),
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        rated.add(i);
                      } else {
                        rated.remove(i);
                      }
                    }),
                  ),
                Text('Bei akutem Risiko hat die Sicherheit Vorrang.',
                    style: TextStyle(
                        fontSize: 12.5, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _criteria = <String>[
    'Leitsymptome genannt',
    'Differenzialdiagnosen genannt',
    'Komorbiditäten bedacht',
    'Risiko und Notfall eingeschätzt',
    'Rechtlich und fachlich angemessenes Vorgehen',
  ];
}
