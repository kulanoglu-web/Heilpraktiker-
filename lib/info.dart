import 'package:flutter/material.dart';

import 'theme.dart';

/// Autor und fachlicher Hintergrund.
const kAuthorName = 'Erdogan Kulanoglu';
const kAuthorTitles = [
  'Psychologe M.Sc.',
  'Sozialarbeiter/Sozialpädagoge B.A.',
  'Heilpraktiker (eingeschränkt auf den Bereich Psychotherapie)',
];
const kVersion = String.fromEnvironment('APP_VERSION', defaultValue: 'Entwicklung');
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
            child: Text('Info & Lernhinweise',
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
          _section('Offline lernen',
              'Alle Fragen, Antworten, Lernkarten und Fälle sind auf dem Gerät gespeichert. Die App benötigt zum Lernen keine Internetverbindung und öffnet keine externen Webseiten. Der Lernfortschritt bleibt lokal auf diesem Gerät.'),
          _section('Medikamente und körperliche Ursachen',
              'Die Inhalte dienen dem Erkennen und Einordnen von Krankheitsbildern und Warnzeichen. Verschreibungspflichtige Psychopharmaka werden ärztlich verordnet und angepasst. Körperliche Ursachen sowie gefährliche Arzneimittelwirkungen müssen medizinisch abgeklärt werden.'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
