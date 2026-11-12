import 'package:flutter/material.dart';
import 'theme.dart';

class CurriculumNode {
  final String title;
  final String summary;
  final List<CurriculumNode> children;
  const CurriculumNode(this.title, this.summary, [this.children = const []]);
}

const curriculum = <CurriculumNode>[
  CurriculumNode('ICD-10 & ICD-11 · Kriterien', 'Zeitkriterien, Voraussetzungen, Leitsymptome, Schweregrad, Komorbidität und Differenzialdiagnostik.', [
    CurriculumNode('ICD-10 Kriterien', 'Dauer, erforderliche Symptome, Ausschluss- und Zusatzkriterien.'),
    CurriculumNode('ICD-11 Kriterien', 'Diagnosemerkmale, Dauer und Abgrenzungen im Überblick.'),
    CurriculumNode('Leitsymptomatik & Schweregrad', 'Welche Kriterien stehen im Vordergrund und wie stark ist die Beeinträchtigung?'),
    CurriculumNode('Komorbidität & Differenzialdiagnostik', 'Hauptdiagnose, Begleiterkrankungen und somatische Ursachen.'),
    CurriculumNode('Leitlinien', 'Indikation, Diagnostik, Verlauf und Behandlungsplanung als Lernfelder.')
  ]),
  CurriculumNode('Gesetzeskunde', 'Gesetze, Tätigkeitsgrenzen und Pflichten für HPP.', [
    CurriculumNode('Heilpraktikergesetz & Erlaubnis', 'Erlaubnisumfang und Grenzen der HPP-Tätigkeit.'),
    CurriculumNode('Verbote, Tätigkeitsgrenzen & Weiterverweisung', 'Was HPP nicht dürfen und wann ärztlich abzuklären ist.'),
    CurriculumNode('Pflichten, Sorgfalt & Berufsordnung', 'Sorgfaltspflicht, Aufklärung, Dokumentation und berufliche Standards.'),
    CurriculumNode('Schweigepflicht & Strafgesetzbuch', 'Vertraulichkeit und gesetzliche Ausnahmen.'),
    CurriculumNode('Psychotherapeutengesetz', 'Berufsrechtliche Einordnung und Abgrenzung zur HPP-Erlaubnis.'),
    CurriculumNode('PsychKG & Unterbringung', 'Landesrechtliche Regeln und Krisenwege; örtliche Zuständigkeit beachten.'),
    CurriculumNode('BGB, Betreuungsrecht & Geschäftsfähigkeit', 'Einwilligung, Vertretung, Betreuung und Geschäftsfähigkeit.'),
    CurriculumNode('Patientenrechte & Behandlungsvertrag', 'Aufklärung, Einwilligung, Dokumentation und Vertrag.'),
    CurriculumNode('DSGVO & Datenschutz', 'Gesundheitsdaten, Aufbewahrung, Zugriff und Betroffenenrechte.'),
    CurriculumNode('HWG · Heilmittelwerbegesetz', 'Grenzen gesundheitsbezogener Werbung.'),
    CurriculumNode('AMG · Arzneimittelgesetz', 'Arzneimittelwissen und Abgrenzung der HPP-Befugnisse.'),
    CurriculumNode('BtMG · Betäubungsmittelgesetz', 'Grundbegriffe, Risiken und Zuständigkeiten.'),
    CurriculumNode('MPDG · Medizinprodukterecht', 'Sicherer und rechtmäßiger Umgang mit Medizinprodukten.'),
    CurriculumNode('IfSG · Infektionsschutzgesetz', 'Infektionsschutz und Meldepflichten.'),
    CurriculumNode('Rehabilitationsträger & Schuldfähigkeit', 'Grundbegriffe und Grenzen der eigenen Einschätzung.')
  ]),
  CurriculumNode('Hygiene', 'Hygienische Grundlagen der Praxis.', [
    CurriculumNode('Händehygiene & Flächendesinfektion', 'Indikationen, Ablauf und Dokumentation.'),
    CurriculumNode('Infektionsprävention', 'Schutz von Patientinnen, Patienten und Behandelnden.'),
    CurriculumNode('Praxisräume & Material', 'Reinigung, Aufbereitung und sichere Entsorgung.')
  ]),
  CurriculumNode('Untersuchung & Diagnostik', 'Befunderhebung, Screening und ärztliche Abklärung.', [
    CurriculumNode('Psychopathologischer Befund', 'Bewusstsein, Orientierung, Denken, Wahrnehmung, Affekt, Antrieb und Risiko.'),
    CurriculumNode('Psychologische Untersuchung & Tests', 'Fragestellung, Auswahl, Grenzen und Interpretation.'),
    CurriculumNode('Mini-Mental-Status-Test (MMST)', 'Einsatz, Durchführung und Aussagegrenzen.'),
    CurriculumNode('Ärztliche Diagnostik', 'Wann Untersuchung, Labor, Bildgebung oder Facharzt nötig sind.'),
    CurriculumNode('Pädiatrische Untersuchung', 'Entwicklungsstand und altersgerechte Befunderhebung.')
  ]),
  CurriculumNode('Elementarfunktionen', 'Grundfunktionen des psychopathologischen Befunds.', [
    CurriculumNode('Bewusstsein & Orientierung', 'Qualitative und quantitative Veränderungen.'),
    CurriculumNode('Aufmerksamkeit & Gedächtnis', 'Konzentration, Merkfähigkeit und Gedächtnis.'),
    CurriculumNode('Denken & Wahrnehmung', 'Formales und inhaltliches Denken, Ich-Erleben und Wahrnehmungsstörungen.'),
    CurriculumNode('Affekt, Antrieb & Psychomotorik', 'Stimmung, Schwingungsfähigkeit, Energie und Bewegung.'),
    CurriculumNode('Schlaf, Appetit & Sexualität', 'Vegetative und weitere Funktionsbereiche.')
  ]),
  CurriculumNode('Psychiatrische Grundlagen', 'Ätiologie, triadisches System und Diagnosesysteme.', [
    CurriculumNode('Ätiologie psychischer Störungen', 'Biologische, psychologische und soziale Faktoren.'),
    CurriculumNode('Triadisches System', 'Organische, psychogene und endogene Erklärungsmodelle einordnen.'),
    CurriculumNode('Diagnosesysteme', 'ICD, DSM und klinische Diagnostik unterscheiden.')
  ]),
  CurriculumNode('ICD-11 · Lernübersicht', 'Aufbau der ICD-11 und Vergleich mit ICD-10.', [
    CurriculumNode('Aufbau & Kapitel', 'Struktur und Kodierlogik.'),
    CurriculumNode('Psychische und neuroentwicklungsbezogene Störungen', 'Überblick über Diagnosegruppen.'),
    CurriculumNode('ICD-10 / ICD-11 Vergleich', 'Begriffe, Kriterien und Umstellungen.')
  ]),
  CurriculumNode('ICD-10 · Psychiatrische Krankheitsbilder', 'F-Kapitel, Diagnostik und Differenzialdiagnosen.', [
    CurriculumNode('F0 · Organische psychische Störungen', 'F00–F03 Demenzen; F04 amnestisches Syndrom; F05 Delir; F06 andere organische Störungen; F07 organische Persönlichkeits- und Verhaltensstörung; F09 nicht näher bezeichnet.'),
    CurriculumNode('F1 · Substanzbezogene Störungen', 'F10–F19: Alkohol und andere psychotrope Substanzen; Intoxikation, schädlicher Gebrauch, Abhängigkeit und Entzug; zusätzlich nichtstoffgebundene Abhängigkeiten.'),
    CurriculumNode('F2 · Schizophrenie, schizotype und wahnhafte Störungen', 'F20 Schizophrenie; F21 schizotype Störung; F22 anhaltender Wahn; F23 akute vorübergehende Psychose; F24 induzierter Wahn; F25 schizoaffektiv; F28/F29 andere oder nicht näher bezeichnete Psychosen.'),
    CurriculumNode('F3 · Affektive Störungen', 'F30 Manie; F31 bipolar; F32 depressive Episode; F33 rezidivierende Depression; F34 anhaltende affektive Störung; F38/F39 sonstige oder nicht näher bezeichnete Störung.'),
    CurriculumNode('F4 · Neurotische, Belastungs- und somatoforme Störungen', 'F40 Phobien; F41 Angst; F42 Zwang; F43 Belastungsreaktionen und Anpassung; F44 dissoziativ; F45 somatoform; F48 sonstige neurotische Störungen.'),
    CurriculumNode('F5 · Verhaltensauffälligkeiten mit körperlichen Faktoren', 'F50 Essstörungen; F51 nichtorganischer Schlaf; F52 sexuelle Funktionsstörung; F53 Wochenbett; F54 psychische Faktoren bei körperlichen Krankheiten; F55 schädlicher Gebrauch nichtabhängigkeitserzeugender Substanzen.'),
    CurriculumNode('F6 · Persönlichkeits- und Verhaltensstörungen', 'F60–F61 Persönlichkeitsstörungen; F62 andauernde Änderung; F63 Impulskontrolle; F64–F66 Geschlechtsidentität und Sexualität (historische ICD-10-Einordnung); F68 sonstige Störungen.'),
    CurriculumNode('F7 · Intelligenzminderung', 'F70–F79: Schweregrade, adaptive Fähigkeiten, Testdiagnostik und Unterstützung.'),
    CurriculumNode('F8 · Entwicklungsstörungen', 'F80–F89: Sprache, schulische Fertigkeiten, Motorik und Entwicklung.'),
    CurriculumNode('F9 · Beginn in Kindheit und Jugend', 'F90 hyperkinetisch; F91 Sozialverhalten; F92 kombiniert; F93 emotional; F94 soziale Funktionen; F98 sonstige Verhaltens- und emotionale Störungen.'),
    CurriculumNode('F99 · Nicht näher bezeichnete psychische Störung', 'Einordnung, wenn keine spezifischere Diagnose möglich ist.'),
    CurriculumNode('R45.8 · Suizidalität', 'Direkt explorieren, akute Sicherheit priorisieren, Hilfe einbeziehen und Vorgehen dokumentieren.')
  ]),
  CurriculumNode('Psychotherapieverfahren', 'Verfahren, Methoden, Setting und Indikation.', [
    CurriculumNode('Setting & Richtungen', 'Einzel, Gruppe, Paar, Familie und Überblick.'),
    CurriculumNode('Psychodynamisch', 'Psychoanalyse, tiefenpsychologisch fundierte Psychotherapie und KIP.'),
    CurriculumNode('Verhaltenstherapie', 'Konditionierung, KVT, REVT nach Ellis, Beck, DBT, soziales Kompetenztraining, Selbstmanagement, Selbstinstruktion, Gedankenstopp, Rollenspiel und CBASP.'),
    CurriculumNode('Humanistisch & erlebnisorientiert', 'Personenzentrierte Gesprächstherapie nach Rogers, Gestalttherapie, Psychodrama und Logotherapie.'),
    CurriculumNode('Systemische Psychotherapie', 'Auftragsklärung, Ressourcen und Beziehungskontext.'),
    CurriculumNode('Entspannungsverfahren', 'PMR nach Jacobson, autogenes Training nach Schultz und Biofeedback.'),
    CurriculumNode('Traumatherapie & EMDR', 'Stabilisierung, Indikation, Phasen und Grenzen.'),
    CurriculumNode('Weitere Methoden', 'Psychoedukation, Hypnotherapie nach Erickson, Soziotherapie und motivierende Gesprächsführung.'),
    CurriculumNode('Biologische Verfahren', 'Lichttherapie, Wachtherapie und EKT als ärztliche Verfahren.'),
    CurriculumNode('Indikation & Kontraindikationen', 'Verfahren passend zum Störungsbild wählen; Risiken und Weiterverweisung beachten.')
  ]),
  CurriculumNode('Psychopharmakologie', 'Wirkstoffgruppen, Nebenwirkungen und Zuständigkeiten.', [
    CurriculumNode('Antidepressiva', 'Gruppen, Wirkungseintritt und relevante Nebenwirkungen.'),
    CurriculumNode('Antipsychotika / Neuroleptika', 'Typische und atypische Wirkstoffe, Wirkung und Risiken.'),
    CurriculumNode('Anxiolytika & Schlafmittel', 'Wirkung, Abhängigkeitspotenzial und Sicherheit.'),
    CurriculumNode('Stimmungsstabilisierer', 'Grundlagen und wichtige Risiken.'),
    CurriculumNode('Nebenwirkungen & Wechselwirkungen', 'Warnzeichen und ärztliche Abklärung.'),
    CurriculumNode('HPP-Grenzen', 'Keine Verordnung oder eigenständige Medikamentenänderung.')
  ]),
  CurriculumNode('Mündliche Prüfung', 'Fallbearbeitung, Differenzialdiagnostik und Antwortstruktur.', [
    CurriculumNode('Prüfungsmodalitäten der Gesundheitsämter', 'Schriftlich und mündlich getrennt vorbereiten; Vorgaben beim zuständigen Amt prüfen.'),
    CurriculumNode('Fallbeispiele', 'Befund, Risiko, Differenzialdiagnosen und nächster sicherer Schritt.'),
    CurriculumNode('Differenzialdiagnostik', 'Zeitkriterien, Leitsymptome, Schweregrad und Ausschlussdiagnosen.'),
    CurriculumNode('Bewusstlosigkeit & Synkope', 'Akute körperliche Ursachen und Notfallhilfe.'),
    CurriculumNode('B-Symptomatik', 'Fieber, Nachtschweiß und Gewichtsverlust.'),
    CurriculumNode('Gangstörungen & Wesensänderungen', 'Neurologische, medikamentöse, substanzbedingte und psychische Ursachen.'),
    CurriculumNode('Halluzinationen & Wahn', 'Psychose, Delir, Substanzen und neurologische Ursachen.'),
    CurriculumNode('Stupor, Kopfschmerz & Schwindel', 'Warnzeichen und medizinische Abklärung.'),
    CurriculumNode('Herzrasen / Tachykardie', 'Kardiale, endokrine, substanzbedingte und Angstursachen.'),
    CurriculumNode('Beliebte Prüfungsfragen', 'Laut antworten, begründen und nächste Schritte benennen.'),
    CurriculumNode('Lerntechnik 3-2-1', '3 Schritte: einordnen, prüfen, handeln. 2 Blickrichtungen: psychisch und somatisch. 1 Priorität: Sicherheit.')
  ]),
  CurriculumNode('Somatische Erkrankungen & Anatomie', 'Körperliche Ursachen erkennen und sicher abklären lassen.', [
    CurriculumNode('Bewegungsapparat', 'Rheumatoide Arthritis und Fibromyalgiesyndrom.'),
    CurriculumNode('Gastrointestinaltrakt', 'Colitis ulcerosa, Morbus Crohn und Ulkus.'),
    CurriculumNode('Geschlechtsorgane & Hormone', 'Schwangerschaft, Wochenbett und Wechseljahre.'),
    CurriculumNode('Haut', 'Neurodermitis, Psoriasis und Urtikaria.'),
    CurriculumNode('Herz-Kreislauf', 'Hypertonie und Warnzeichen.'),
    CurriculumNode('Hormonsystem & Stoffwechsel', 'Hypothyreose, Hyperthyreose, Adipositas, Diabetes mellitus und metabolisches Syndrom.'),
    CurriculumNode('Leber', 'Leberzirrhose und Virushepatitis A–E.'),
    CurriculumNode('Neurologie', 'Huntington, Epilepsie, Hirnblutung, Hirntumoren, Kopfschmerz, Lähmung, MS, Parkinson, Schädel-Hirn-Trauma, Schlaganfall und ME/CFS.'),
    CurriculumNode('Ohr & Gleichgewicht', 'Tinnitus und Schwindel.'),
    CurriculumNode('Respirationstrakt', 'Asthma bronchiale und Atemnot.')
  ]),
  CurriculumNode('Infektionskrankheiten', 'Infektionen mit neurologischen oder psychischen Symptomen.', [
    CurriculumNode('Borna & Borreliose', 'Verlauf und neurologische Beschwerden.'),
    CurriculumNode('COVID-19', 'Akute und länger anhaltende Beschwerden.'),
    CurriculumNode('Creutzfeldt-Jakob-Krankheit', 'Rasche kognitive und neurologische Verschlechterung.'),
    CurriculumNode('Enzephalitis & Meningitis', 'Warnzeichen und sofortige medizinische Abklärung.'),
    CurriculumNode('FSME', 'Zeckenübertragene Infektion.'),
    CurriculumNode('HIV / AIDS', 'Mögliche neurologische und psychische Begleiterscheinungen.'),
    CurriculumNode('Meningokokken-Meningitis & Sepsis', 'Lebensbedrohliche Warnzeichen.'),
    CurriculumNode('Syphilis & Tollwut', 'Spätfolgen, Prävention und Versorgung.')
  ]),
  CurriculumNode('Notfälle', 'Erkennen, priorisieren und Hilfe organisieren.', [
    CurriculumNode('Rettungskette & Notruf', 'Eigenschutz, Notruf, Erste Hilfe und Übergabe.'),
    CurriculumNode('Defibrillator & Wiederbelebung', 'Grundlagen und AED.'),
    CurriculumNode('Lagerung & Schock', 'Situationsgerechte Lagerung und Warnzeichen.'),
    CurriculumNode('Psychiatrische Notfälle', 'Akute Psychose, Erregung, Intoxikation und fehlende Selbstversorgung.'),
    CurriculumNode('Suizidale Krise', 'Akute Sicherheit, Krisenhilfe, Zuständigkeit und Dokumentation.'),
    CurriculumNode('Notfallplan & Anlaufstellen', 'Kontakte und nächster Schritt im Hilfesystem.')
  ]),
  CurriculumNode('Praxisgründung & Praxisführung', 'Organisatorische Grundlagen und Checklisten.', [
    CurriculumNode('Gründungscheckliste', 'Erlaubnis, Anmeldung, Räume und Versicherung.'),
    CurriculumNode('Datenschutz & Dokumentation', 'Akten, Aufbewahrung, Zugriff und sichere Kommunikation.'),
    CurriculumNode('Aufklärung, Honorar & Ausfallregeln', 'Klare Vereinbarungen vor Beginn.'),
    CurriculumNode('Krisen- & Weiterverweisungsplan', 'Kontakte, Notfallwege und Grenzen des Angebots.')
  ]),
  CurriculumNode('Fachbegriffe & Glossar', 'Psychiatrische, medizinische und praxisbezogene Begriffe.', [
    CurriculumNode('Psychiatrische Fachbegriffe', 'Begriffe aus Befund und Diagnostik.'),
    CurriculumNode('Medizinische Fachbegriffe', 'Anatomie, Symptome und Untersuchungen.'),
    CurriculumNode('Abkürzungen', 'ICD, MMST, PMR, AT, DBT, KVT, EMDR, EKT und weitere.')
  ])
];

class CurriculumScreen extends StatelessWidget {
  final List<CurriculumNode> nodes;
  final String title;
  const CurriculumScreen({super.key, this.nodes = curriculum, this.title = 'Lernstruktur'});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: plainAppBar(title),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        SoftCard(gradient: brandGradient(), child: const Text(
          'Wähle ein Kapitel und arbeite die Themen schrittweise durch. Die Struktur dient als Lernplan; konkrete medizinische Kriterien, Gesetze und Prüfungsmodalitäten sind vor Anwendung anhand aktueller Fachinformationen zu lernen.',
          style: TextStyle(color: Colors.white, height: 1.5))),
        const SizedBox(height: 14),
        for (var i = 0; i < nodes.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SoftCard(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => nodes[i].children.isEmpty
                  ? CurriculumTopicScreen(node: nodes[i])
                  : CurriculumScreen(nodes: nodes[i].children, title: nodes[i].title))),
              child: Row(children: [
                CircleAvatar(radius: 17, backgroundColor: tint(kAccent, 0.15),
                  child: Text((i + 1).toString(), style: const TextStyle(color: kAccent, fontWeight: FontWeight.w800))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(nodes[i].title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
                  const SizedBox(height: 4),
                  Text(nodes[i].summary, style: const TextStyle(height: 1.35))
                ])),
                const Icon(Icons.chevron_right_rounded)
              ]),
            ),
          )
      ],
    ),
  );
}

class CurriculumTopicScreen extends StatefulWidget {
  final CurriculumNode node;
  const CurriculumTopicScreen({super.key, required this.node});
  @override
  State<CurriculumTopicScreen> createState() => _CurriculumTopicScreenState();
}

class _CurriculumTopicScreenState extends State<CurriculumTopicScreen> {
  String difficulty = 'Mittel';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: plainAppBar(widget.node.title),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      SoftCard(gradient: brandGradient(), child: Text(widget.node.summary,
        style: const TextStyle(color: Colors.white, height: 1.5))),
      const SizedBox(height: 16),
      const Text('Lernstufe', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'Leicht', label: Text('Leicht')),
          ButtonSegment(value: 'Mittel', label: Text('Mittel')),
          ButtonSegment(value: 'Schwer', label: Text('Schwer'))
        ],
        selected: {difficulty},
        onSelectionChanged: (value) => setState(() => difficulty = value.first)),
      const SizedBox(height: 12),
      _card('Definition', 'Erkläre den Begriff in einem klaren Satz und nenne die Einordnung.'),
      _card('2 Kernpunkte', 'Leitsymptome oder Pflichten; Dauer, Schweregrad, Risiken und Abgrenzungen.'),
      _card('3-Schritte-Abruf', '1. Einordnen. 2. Kriterien, Risiken und Differenzialdiagnosen prüfen. 3. Den nächsten sicheren Schritt nennen.'),
      _card('Prüfungsantwort', 'Zuerst frei antworten, dann begründen und Unsicherheiten sowie nötige Weiterverweisung benennen.'),
      Text(difficulty == 'Leicht' ? 'Übe Definitionen und Schlüsselbegriffe.' : difficulty == 'Mittel' ? 'Wende Kriterien an und nenne zwei Abgrenzungen.' : 'Begründe einen Fall und priorisiere Komorbidität und Risiken.', style: const TextStyle(height: 1.5)),
      const SizedBox(height: 12),
      const Text('Ausführliche Inhalte zu diesem Thema werden schrittweise ergänzt.', style: TextStyle(fontSize: 12.5))
    ]),
  );

  Widget _card(String title, String body) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SoftCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 6),
      Text(body, style: const TextStyle(height: 1.5))
    ])),
  );
}
