import 'package:flutter/material.dart';

import 'models.dart';

/// Lernkarteien nach Themenbereichen.
class FlashcardScreen extends StatefulWidget {
  final List<Flashcard> cards;
  const FlashcardScreen({super.key, required this.cards});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  String? topic;
  late List<Flashcard> deck;
  Set<String> known = {};
  int pos = 0;
  bool flipped = false;

  @override
  void initState() {
    super.initState();
    deck = List.of(widget.cards)..shuffle();
    Progress.ids(Progress.knownKey).then((s) {
      if (mounted) setState(() => known = s);
    });
  }

  List<String> get topics =>
      widget.cards.map((c) => c.topic).toSet().toList()..sort();

  void setTopic(String? t) {
    setState(() {
      topic = t;
      deck = widget.cards.where((c) => t == null || c.topic == t).toList()
        ..shuffle();
      pos = 0;
      flipped = false;
    });
  }

  Future<void> rate(bool knewIt) async {
    final c = deck[pos];
    if (knewIt) {
      known.add(c.id);
      await Progress.addAll(Progress.knownKey, [c.id]);
    } else {
      known.remove(c.id);
      await Progress.removeAll(Progress.knownKey, [c.id]);
    }
    setState(() {
      pos = (pos + 1) % deck.length;
      flipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = deck.isEmpty ? null : deck[pos];
    return Scaffold(
      appBar: AppBar(title: const Text('Lernkarteien')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Alle'),
                      selected: topic == null,
                      onSelected: (_) => setTopic(null),
                    ),
                  ),
                  for (final t in topics)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t),
                        selected: topic == t,
                        onSelected: (_) => setTopic(t),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Gewusst: ${known.length} von ${widget.cards.length}'),
            const SizedBox(height: 12),
            if (card == null)
              const Expanded(child: Center(child: Text('Keine Karten')))
            else
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => flipped = !flipped),
                  child: Card(
                    child: SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(card.topic,
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 16),
                              Text(
                                flipped ? card.back : card.front,
                                textAlign: TextAlign.center,
                                style: flipped
                                    ? Theme.of(context).textTheme.bodyLarge
                                    : Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                flipped
                                    ? ''
                                    : 'Tippen, um die Antwort zu zeigen',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: card == null ? null : () => rate(false),
                    child: const Text('Nochmal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: card == null ? null : () => rate(true),
                    child: const Text('Gewusst'),
                  ),
                ),
              ],
            ),
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
      appBar: AppBar(title: const Text('Mündliche Prüfung')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            minutes == null
                ? 'Dauer im Profil ${profile.name}: beim Amt erfragen.'
                : 'Dauer im Profil ${profile.name}: ca. $minutes Minuten.',
          ),
          const SizedBox(height: 12),
          for (final c in cases)
            Card(
              child: ListTile(
                title: Text(c.title),
                subtitle: Text('${c.questions.length} Fragen'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OralCaseScreen(oralCase: c),
                )),
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

  @override
  Widget build(BuildContext context) {
    final c = widget.oralCase;
    return Scaffold(
      appBar: AppBar(title: Text(c.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(c.vignette),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Beantworte jede Frage zuerst laut in eigenen Worten. '
            'Dann die Musterantwort aufdecken und vergleichen.',
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < c.questions.length; i++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${i + 1}. ${c.questions[i].question}',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    if (shown.contains(i))
                      Text(c.questions[i].answer)
                    else
                      TextButton(
                        onPressed: () => setState(() => shown.add(i)),
                        child: const Text('Musterantwort zeigen'),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
