import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme.dart';

/// Hier Namen und Links der Praxis pflegen.
const kAuthorName = 'Erdogan Kulanoglu';
const kAuthorTitles = [
  'Psychologe M.Sc.',
  'Sozialarbeiter/Sozialpädagoge B.A.',
  'Heilpraktiker (eingeschränkt auf den Bereich Psychotherapie)',
];
const kVersion = String.fromEnvironment('APP_VERSION', defaultValue: 'Entwicklung');
const kWebsite = 'https://www.psychologe-spandau.de';
const kReviewUrl =
    'https://g.page/r/Ccxj8Rnh_iwAEB0/review';

Future<void> _open(BuildContext context, String url) async {
  final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Link konnte nicht geöffnet werden.')));
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});
  @override
  Widget build(BuildContext context) => SoftCard(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const InfoScreen())),
        child: Row(children: [
          const Icon(Icons.info_outline_rounded, color: kBrand, size: 28),
          const SizedBox(width: 14),
          const Expanded(
            child: Text('Info, Haftungsausschluss & Feedback',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
          const Icon(Icons.chevron_right_rounded),
        ]),
      );
}

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  Widget _section(String title, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SoftCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(height: 1.45)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: plainAppBar('Info'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SoftCard(
            gradient: brandGradient(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HP Psychotherapie Trainer',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),
                SizedBox(height: 6),
                Text('Version $kVersion',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text('Entwickelt von $kAuthorName',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text(
                    kAuthorTitles.join('\n'),
                    style: TextStyle(color: Colors.white70, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _section('Ohne Gewähr',
              'Alle Inhalte (Fragen, Kernkarten, Fälle, Erklärungen) dienen ausschließlich der Prüfungsvorbereitung und wurden mit Sorgfalt erstellt, erfolgen aber ohne Gewähr auf Richtigkeit, Vollständigkeit und Aktualität. Es handelt sich nicht um Original-Prüfungsfragen. Verbindlich sind die Vorgaben des zuständigen Gesundheitsamts und die aktuelle Rechtslage. Die App ersetzt weder Fachliteratur noch ärztliche, psychotherapeutische oder rechtliche Beratung.'),
          _section('Fehler melden',
              'Ist dir ein Fehler aufgefallen, etwa eine falsche Antwort, ein Tippfehler oder eine veraltete Angabe? Bitte melde ihn über die Praxis-Website. So wird die App für alle besser.'),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FilledButton.icon(
              onPressed: () => _open(context, kWebsite),
              icon: const Icon(Icons.language_rounded),
              label: const Text('www.psychologe-spandau.de'),
            ),
          ),
          _section('Als Dank',
              'Wenn dir die App beim Lernen hilft, freue ich mich über eine Google-Rezension für die Privatpraxis.'),
          FilledButton.tonalIcon(
            onPressed: () => _open(context, kReviewUrl),
            icon: const Icon(Icons.star_rounded),
            label: const Text('Rezension bei Google schreiben'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
