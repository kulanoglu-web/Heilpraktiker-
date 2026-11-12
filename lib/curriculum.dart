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

const curriculumNotes = <String, List<String>>{
  'ICD-10 Kriterien': [
    'Die ICD-10-GM ist die deutsche Modifikation für die Kodierung. Für Lernen und Prüfung zählt: Diagnose nicht aus einem Einzelzeichen ableiten, sondern Symptomkonstellation, Dauer, Verlauf, Beeinträchtigung und Ausschlüsse zusammen prüfen.',
    'Prüfraster: 1) Leitsymptome und Anzahl, 2) Mindestdauer und zeitlicher Verlauf, 3) Leidensdruck und Funktionsbeeinträchtigung, 4) Substanzen und körperliche Ursachen, 5) Komorbidität und Risiko.',
    'Zeitkriterien sind störungsspezifisch. Karteikarten sollten die jeweilige ICD-Version und konkrete Diagnose nennen; eine einzige allgemeine Mindestdauer gibt es nicht.'
  ],
  'ICD-11 Kriterien': [
    'Die ICD-11 ist die internationale WHO-Klassifikation. Klinische Beschreibungen und diagnostische Anforderungen sind ein eigener Lernzugang; die deutsche ICD-10-GM bleibt für deutsche Kodierung relevant.',
    'Vergleiche pro Störung: Name und Untergruppen, Kernmerkmale, Dauer oder Verlauf, Ausschlusskriterien, Funktionsbeeinträchtigung und Abgrenzung.',
    'Lernregel: ICD-10- und ICD-11-Codes nicht ungeprüft gleichsetzen. Bei einer Prüfungsfrage zuerst benennen, auf welches System sich die Frage bezieht.'
  ],
  'Leitsymptomatik & Schweregrad': [
    'Leitsymptome sind die Merkmale, die das Störungsbild prägen. Prüfe, ob sie zusammen auftreten, wie lange sie bestehen und ob sie Alltag, Beziehungen, Ausbildung oder Arbeit beeinträchtigen.',
    'Schweregrad ergibt sich aus Symptomzahl und -intensität, Funktionsverlust, Verlauf, Selbstgefährdung und notwendiger Unterstützung. Nicht allein aus einem Fragebogenwert ableiten.',
    'Erfrage auch Ressourcen, Schutzfaktoren, frühere Episoden und die Sicht der betroffenen Person.'
  ],
  'Komorbidität & Differenzialdiagnostik': [
    'Zuerst akute Gefahren und körperliche Warnzeichen prüfen. Danach Verlauf, Beginn, Substanzen und Medikamente erheben; passende psychische Diagnosen und Komorbiditäten gegeneinander abwägen.',
    'Eine Differenzialdiagnose ist eine prüfbare Alternative, keine Ferndiagnose: Was spricht dafür, was dagegen, welche Information fehlt und wer kann sie medizinisch klären?',
    'Neue, plötzlich einsetzende oder fluktuierende psychische Veränderungen, Bewusstseinsstörung, Fieber, neurologische Ausfälle oder Intoxikationsverdacht erfordern dringliche ärztliche Abklärung.'
  ],
  'Verbote, Tätigkeitsgrenzen & Weiterverweisung': [
    'Die Erlaubnis ist an ihren konkreten Umfang gebunden. Eine auf Psychotherapie beschränkte Erlaubnis umfasst keine allgemeine somatische Behandlung.',
    'HPP für Psychotherapie verschreiben keine verschreibungspflichtigen Arzneimittel und stellen keine ärztlichen Atteste oder Krankschreibungen aus. Medikamente weder empfehlen abzusetzen noch eigenmächtig zu verändern.',
    'Bei körperlichen Warnzeichen, unklarer Ursache, erheblicher Selbst- oder Fremdgefährdung oder fehlender eigener Kompetenz: Behandlung begrenzen, medizinische Hilfe vermitteln und Vorgehen dokumentieren.'
  ],
  'Pflichten, Sorgfalt & Berufsordnung': [
    'Vor Behandlungsbeginn Auftrag, Ziel, Vorgehen, Grenzen, Honorar, Ausfallregel und Alternativen verständlich klären. Einwilligung muss freiwillig und informiert sein.',
    'Fachlich sorgfältig arbeiten: Anamnese, Befund, Hypothesen, Risiko, vereinbarte Schritte und Verlauf zeitnah dokumentieren. Keine Diagnose oder Wirksamkeitsgarantie versprechen, die nicht begründet ist.',
    'Regelmäßig Kompetenzgrenzen prüfen, Fortbildung sichern und bei Bedarf kollegiale Beratung, ärztliche Abklärung oder Weiterverweisung nutzen.'
  ],
  'Schweigepflicht & Strafgesetzbuch': [
    'Vertraulichkeit ist Kern der therapeutischen Beziehung. Gesundheitsdaten nur mit tragfähiger Rechtsgrundlage und so sparsam wie möglich verarbeiten oder weitergeben.',
    'Für Heilpraktiker ist die strafrechtliche Einordnung nach §203 StGB nicht pauschal mit approbierten Heilberufen gleichzusetzen. Zivilrechtliche, vertragliche und datenschutzrechtliche Pflichten bleiben bestehen; Sonderfälle rechtlich prüfen.',
    'Vor Weitergabe an Angehörige, Arbeitgeber oder andere Stellen grundsätzlich eine wirksame Einwilligung klären. Bei akuter Gefahr gelten besondere Abwägungen und Notfallwege.'
  ],
  'Patientenrechte & Behandlungsvertrag': [
    'Der Behandlungsvertrag regelt die vereinbarte Behandlung und Vergütung. Vorher transparent über Methode, erwartbaren Verlauf, Risiken, Grenzen und Alternativen informieren.',
    'Die Behandlungsakte zeitnah führen; wesentliche Anamnese, Befunde, Aufklärung, Einwilligung, Maßnahmen und deren Wirkung nachvollziehbar festhalten. Änderungen so dokumentieren, dass frühere Einträge erkennbar bleiben.',
    'Patientinnen und Patienten haben Rechte auf Einsicht und Kopien im gesetzlichen Rahmen. Für Aufbewahrungsfristen und Ausnahmen aktuelle Rechtslage beachten.'
  ],
  'DSGVO & Datenschutz': [
    'Gesundheitsdaten sind besonders schützenswerte personenbezogene Daten. Erhebe nur, was für den Zweck erforderlich ist; informiere über Zweck, Rechtsgrundlage, Speicherdauer und Rechte.',
    'Zugriff beschränken, Geräte schützen, sichere Übertragung nutzen und Akten vor unbefugter Einsicht schützen. Papierakten sicher verwahren; Lösch- und Aufbewahrungsfristen abstimmen.',
    'Einwilligung ist nicht automatisch die einzige mögliche Rechtsgrundlage. Für konkrete Praxisprozesse Datenschutzberatung einholen.'
  ],
  'Psychopathologischer Befund': [
    'Beschreibe zunächst beobachtbare Befunde neutral und konkret. Trenne Patientenaussage, eigene Beobachtung und Interpretation.',
    'Prüfreihenfolge: Bewusstsein und Orientierung; Aufmerksamkeit und Gedächtnis; formales und inhaltliches Denken; Wahrnehmung und Ich-Erleben; Stimmung und Affekt; Antrieb und Psychomotorik; Schlaf, Appetit und Suizidalität.',
    'Erfasse Beginn, Dauer, Schwankungen, Alltagseinfluss, Medikamente und Substanzen. Ein Befund ist eine Momentaufnahme, keine Diagnose für sich.'
  ],
  'Psychologische Untersuchung & Tests': [
    'Vor jedem Test die Fragestellung bestimmen: Screening, Verlaufskontrolle oder vertiefte Diagnostik? Prüfe Alter, Sprache, Normgruppe, Validität und Rahmenbedingungen.',
    'Ein Screening kann einen Verdacht anzeigen, aber keine Diagnose allein bestätigen oder ausschließen. Werte immer mit Gespräch, Befund und Funktionsniveau verbinden.',
    'Bei Tests außerhalb der eigenen Qualifikation keine Interpretation vortäuschen. Ergebnisse und Grenzen verständlich erklären.'
  ],
  'Mini-Mental-Status-Test (MMST)': [
    'Der MMST ist ein kurzes kognitives Screening, unter anderem für Orientierung, Merkfähigkeit, Aufmerksamkeit, Erinnerung und Sprache.',
    'Ein niedriger Wert beweist keine Demenz; ein normaler Wert schließt frühe oder umschriebene kognitive Störungen nicht aus. Bildung, Sprache, Hören, Sehen, Müdigkeit und akute Erkrankung beeinflussen die Leistung.',
    'Bei neuem oder raschem Abbau ärztliche Abklärung veranlassen; Delir und akute neurologische Ursachen haben Vorrang.'
  ],
  'Ärztliche Diagnostik': [
    'Psychische Beschwerden können körperliche oder medikamentöse Ursachen haben. Die somatische Abklärung richtet sich nach Anamnese, Untersuchung und Warnzeichen und gehört in ärztliche Hände.',
    'Prüfungsklassiker: Schilddrüsenfunktionsstörung, Anämie, Infektion, Stoffwechselentgleisung, neurologische Erkrankung, Schlafstörung sowie Wirkungen und Entzug von Substanzen.',
    'Bei plötzlichem Beginn, Verwirrtheit, Fieber, Bewusstseinsänderung, Krampfanfall, neuen Lähmungen oder starken ungewohnten Schmerzen: akut medizinisch abklären lassen.'
  ],
  'F0 · Organische psychische Störungen': [
    'F00–F09 umfasst organische einschließlich symptomatischer psychischer Störungen. Eine körperliche oder neurologische Ursache muss mitgedacht und medizinisch geklärt werden.',
    'Delir (F05) beginnt typischerweise akut und kann im Tagesverlauf schwanken; Aufmerksamkeit und Bewusstseinslage sind verändert. Das ist ein medizinischer Notfallverdacht, keine primäre Psychotherapie-Diagnose.',
    'Demenzen (F00–F03) verlaufen meist über längere Zeit mit kognitivem Abbau und Alltagsverlust. Plötzliche Verschlechterung spricht für zusätzliche akute Ursachen.'
  ],
  'F1 · Substanzbezogene Störungen': [
    'Für F10–F19 sind Substanz, Menge, Häufigkeit, letzter Konsum, Toleranz, Kontrollverlust, Entzug und Folgen zu erheben. Fremdanamnese kann mit Einwilligung wichtige Ergänzung sein.',
    'Intoxikation, schädlicher Gebrauch, Abhängigkeit und Entzug sind unterschiedliche Zustände. Halluzination, Krampfanfall, Bewusstseinsstörung oder schwerer Entzug erfordern sofortige medizinische Hilfe.',
    'Auch verschriebene Medikamente, Mischkonsum, Koffein und frei erhältliche Substanzen erfragen. Nicht abruptes Absetzen oder Entzug zu Hause empfehlen.'
  ],
  'F2 · Schizophrenie, schizotype und wahnhafte Störungen': [
    'Psychoseverdacht anhand von Wahn, Halluzinationen, Ich-Störungen, Desorganisation, Negativsymptomen, Verlauf und Funktionsverlust strukturieren. Inhalt allein genügt nicht.',
    'Akut immer Delir, neurologische oder endokrine Ursachen, Medikamente und Substanzen abgrenzen lassen. Erstmalige oder rasch zunehmende Psychose braucht zeitnahe fachärztliche Abklärung.',
    'Sicherheit, Schlaf, Selbstversorgung, Suizid- und Fremdgefährdung sowie verfügbare Unterstützung priorisieren. Nicht konfrontativ über Wahninhalte streiten.'
  ],
  'F3 · Affektive Störungen': [
    'Bei Depression Stimmung, Interessenverlust und Antrieb sowie weitere kognitive und körperliche Symptome, Dauer, Verlauf und Alltagsbeeinträchtigung erheben.',
    'Vor einer unipolaren Einordnung frühere Hochstimmung, vermindertes Schlafbedürfnis, gesteigerte Aktivität, Enthemmung und Episodenverlauf erfragen: Hinweise auf Bipolarität verändern die Behandlung.',
    'Suizidgedanken direkt und wertfrei ansprechen. Schilddrüse, Medikamente, Substanzen, Trauer, Schlaf und körperliche Erkrankungen als mögliche Mitursachen mitprüfen.'
  ],
  'F4 · Neurotische, Belastungs- und somatoforme Störungen': [
    'Angst: Auslöser, Erwartungsangst, Vermeidung, Paniksymptome, Dauer und Funktionsbeeinträchtigung erheben. Herz-, Atem-, Schilddrüsen- und Substanzursachen bei Bedarf ärztlich abklären.',
    'Zwang: Zwangsgedanken und/oder Handlungen, Zeitaufwand, Leidensdruck, Einsicht und Vermeidung unterscheiden; nicht mit Psychose gleichsetzen.',
    'Belastungs- und dissoziative Symptome im zeitlichen Kontext erheben. Bei körperlichen Beschwerden körperliche Diagnostik nicht durch psychische Erklärung ersetzen.'
  ],
  'F5 · Verhaltensauffälligkeiten mit körperlichen Faktoren': [
    'Essstörungen können akut körperlich gefährlich sein. Gewichtsverlauf, Restriktion, Essanfälle, kompensatorisches Verhalten, Kreislauf und Suizidalität sorgfältig erfassen.',
    'Schlafprobleme anhand von Einschlaf-, Durchschlaf-, Rhythmus- und Tagesfolgen beschreiben; Schlafapnoe, Schmerzen, Medikamente und Substanzen als mögliche Ursachen beachten.',
    'Bei sexuellen Funktionsproblemen körperliche, medikamentöse, partnerschaftliche und psychische Faktoren gemeinsam prüfen und respektvoll fragen.'
  ],
  'F6 · Persönlichkeits- und Verhaltensstörungen': [
    'Persönlichkeitsstörungen beschreiben überdauernde, unflexible Muster mit Leidensdruck oder Beeinträchtigung über verschiedene Lebensbereiche. Einzelne konflikthafte Episoden reichen nicht.',
    'Entwicklung, kultureller Kontext, Selbstbild, Beziehungen, Impulsregulation und Funktionsniveau berücksichtigen. Komorbidität und akute Krisen separat beurteilen.',
    'Diagnostische Begriffe nicht als Werturteil verwenden. Ressourcen, Zusammenarbeit und Sicherheitsplanung in den Vordergrund stellen.'
  ],
  'F9 · Beginn in Kindheit und Jugend': [
    'Für Diagnostik müssen Entwicklungsstand, Beginn, Dauer, mehrere Lebensbereiche und altersübliche Verhaltensvariation berücksichtigt werden.',
    'Informationen aus mehreren Quellen können hilfreich sein: Kind oder Jugendliche selbst, Sorgeberechtigte und – mit passender Rechtsgrundlage und Einwilligung – Schule oder weitere Bezugspersonen.',
    'Schutzauftrag, Einwilligungsfähigkeit, Sorgeberechtigung und Vertraulichkeit sorgfältig auseinanderhalten. Bei Gefährdung geeignete Kinderschutzwege nutzen.'
  ],
  'R45.8 · Suizidalität': [
    'Direkt und ruhig nach Gedanken, Absicht, Plan, verfügbaren Mitteln, zeitlicher Nähe, früheren Versuchen, Schutzfaktoren und Unterstützung fragen. Das Gespräch erhöht nicht automatisch das Risiko.',
    'Bei unmittelbarer Gefahr Person nicht allein lassen, Notruf 112 oder psychiatrischen Krisendienst kontaktieren und sichere Übergabe organisieren. Keine Geheimhaltung versprechen.',
    'Bei nicht unmittelbar drohender, aber relevanter Suizidalität: gemeinsam konkrete nächste Schritte, erreichbare Unterstützung und zeitnahe professionelle Abklärung vereinbaren und dokumentieren.'
  ],
  'Antidepressiva': [
    'Antidepressiva sind verschiedene Wirkstoffgruppen, etwa SSRI, SNRI, trizyklische Antidepressiva und weitere Wirkprinzipien. Wirkbeginn, Nebenwirkungen und Wechselwirkungen unterscheiden sich.',
    'Wichtige Lernfelder: Übelkeit, Schlaf- und Sexualnebenwirkungen, Aktivierung, Absetzsymptome und Wechselwirkungen. Konkrete Risiken hängen vom Präparat und der Person ab.',
    'Auf mögliche manische Symptome, Suizidalität und deutliche Zustandsverschlechterung achten. Verordnung, Dosisänderung und Absetzen gehören in ärztliche Zuständigkeit.'
  ],
  'Antipsychotika / Neuroleptika': [
    'Antipsychotika unterscheiden sich in Rezeptorprofil, Wirkung und Nebenwirkungsrisiken; „typisch“ und „atypisch“ sind grobe Gruppen, keine Garantie für individuelle Verträglichkeit.',
    'Lernfelder: Bewegungsstörungen, Sedierung, Gewicht und Stoffwechsel, Kreislauf, QT-Zeit sowie seltene schwere Reaktionen. Warnsymptome ärztlich abklären lassen.',
    'Medikation nicht eigenständig verändern. Bei Fieber mit Muskelsteife, Bewusstseinsstörung oder schwerer Bewegungsunruhe sofort medizinische Hilfe veranlassen.'
  ],
  'Anxiolytika & Schlafmittel': [
    'Benzodiazepine können rasch beruhigen, bergen aber Risiken wie Sedierung, Toleranz, Abhängigkeit, Stürze und gefährliche Kombination mit Alkohol oder anderen dämpfenden Mitteln.',
    'Nicht eigenständig abrupt absetzen; Entzug kann gefährlich sein. Therapieentscheidungen und Ausschleichen sind ärztlich zu begleiten.',
    'Bei älteren Menschen besonders auf Sturz, Verwirrtheit und Wechselwirkungen achten.'
  ],
  'Prüfungsmodalitäten der Gesundheitsämter': [
    'In Berlin besteht die Kenntnisüberprüfung für die auf Psychotherapie beschränkte Heilpraktikererlaubnis aus einem schriftlichen und einem mündlichen Teil. Organisation, Termine und Unterlagen richten sich nach der zuständigen Stelle.',
    'Schriftlich: prüfe Ausschluss und Risiko, lies jede Frage genau, unterscheide „richtig“ von „am ehesten“, bearbeite sichere Fragen zuerst und reserviere Zeit für Kontrolle.',
    'Mündlich: Befund erheben, akute Gefahr benennen, somatische Ursachen mitdenken, Differenzialdiagnosen begründen, Grenzen erkennen und einen sicheren nächsten Schritt nennen. Lokale Abläufe können abweichen.'
  ],
  'Lerntechnik 3-2-1': [
    '3 Schritte: EINORDNEN (Problem und Leitsymptom), PRÜFEN (Dauer, Risiko, körperliche und substanzbezogene Ursachen), HANDELN (passender nächster sicherer Schritt).',
    '2 Blickrichtungen: psychisch und körperlich. Ergänze Verlauf und soziale Situation, bevor du dich auf eine Diagnose festlegst.',
    '1 Priorität: Sicherheit. Bei akutem Notfall zuerst Hilfe organisieren, dann ausführlicher diagnostizieren.'
  ],
  'Hormonsystem & Stoffwechsel': [
    'Hypothyreose kann unter anderem Müdigkeit, verlangsamtes Denken und depressive Beschwerden begleiten; Hyperthyreose kann Unruhe, Schlafprobleme, Tremor und Herzrasen verursachen. Symptome sind unspezifisch.',
    'Diabetes und Stoffwechselentgleisungen können Konzentration, Stimmung und Bewusstsein beeinflussen. Akute Verwirrtheit, Bewusstseinsminderung oder schwere körperliche Symptome sind medizinisch abzuklären.',
    'HPP stellen keine endokrinologische Diagnose allein aus psychischen Symptomen. Bei passender Anamnese ärztliche Untersuchung und Laborabklärung anregen.'
  ],
  'Neurologie': [
    'Neue Lähmung, Sprach- oder Sehstörung, Gesichtsfeldausfall, plötzlich stärkster Kopfschmerz, Krampfanfall oder rasche Bewusstseinsänderung sind Warnzeichen für einen Notfall.',
    'Halluzinationen, Gedächtnisverlust oder Wesensänderung können bei Epilepsie, Schlaganfall, Hirntumor, Infektion, Parkinson-Erkrankung oder Medikamentenwirkung auftreten.',
    'Bei Verdacht auf Schlaganfall: Zeitpunkt des Symptombeginns merken und sofort 112. Nicht erst einen psychischen Befund vervollständigen.'
  ],
  'Rettungskette & Notruf': [
    'Eigenschutz prüfen, Bewusstsein und Atmung beurteilen, 112 rufen und klar sagen: wo, was, wie viele Betroffene, welche Gefahren und Rückfragen beantworten.',
    'Bei fehlender normaler Atmung Wiederbelebung beginnen und AED holen lassen; den Anweisungen des Geräts folgen. Erste Hilfe regelmäßig praktisch auffrischen.',
    'Psychiatrische Akutgefahr: sichere Umgebung, ruhige Ansprache, klare Grenzen und professionelle Hilfe. Keine körperliche Zwangsmaßnahme eigenständig durchführen.'
  ],
  'Gründungscheckliste': [
    'Vor Aufnahme der Tätigkeit Erlaubnisumfang, Anmeldung, steuerliche Fragen, Berufshaftpflicht, geeignete Räume und sichere Dokumentation klären.',
    'Schriftlich regeln: Angebot und Grenzen, Honorar, Absagebedingungen, Zahlungsweg, Datenschutzinformation und Verhalten im Notfall.',
    'Keine Approbation oder geschützte Berufsbezeichnung suggerieren. Werbung sachlich und nachprüfbar formulieren.'
  ],
  'ICD-10 / ICD-11 Vergleich': [
    'Die ICD-10-GM 2026 ist die deutsche Modifikation zur Diagnosenkodierung. Die ICD-11 ist der WHO-Standard; ihre klinischen Anforderungen sind nicht einfach eine andere Schreibweise der ICD-10.',
    'Lerne die Störung zunächst in einem System sicher und erst danach den Vergleich. Notiere Versionsjahr und Quelle getrennt von den Merkhilfen.',
    'Prüfungswissen kann sich auf ICD-10-GM beziehen; im Zweifel die Aufgabenstellung und das zuständige Gesundheitsamt beachten.'
  ]
};

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
      for (final point in curriculumNotes[widget.node.title] ?? const <String>[]) _card('Lerninhalt', point),
      _card('Definition', 'Erkläre den Begriff in einem klaren Satz und nenne die Einordnung.'),
      _card('2 Kernpunkte', 'Leitsymptome oder Pflichten; Dauer, Schweregrad, Risiken und Abgrenzungen.'),
      _card('3-Schritte-Abruf', '1. Einordnen. 2. Kriterien, Risiken und Differenzialdiagnosen prüfen. 3. Den nächsten sicheren Schritt nennen.'),
      _card('Prüfungsantwort', 'Zuerst frei antworten, dann begründen und Unsicherheiten sowie nötige Weiterverweisung benennen.'),
      Text(difficulty == 'Leicht' ? 'Übe Definitionen und Schlüsselbegriffe.' : difficulty == 'Mittel' ? 'Wende Kriterien an und nenne zwei Abgrenzungen.' : 'Begründe einen Fall und priorisiere Komorbidität und Risiken.', style: const TextStyle(height: 1.5)),
      const SizedBox(height: 12),
      const Text('Die Lernhinweise sind eine Prüfungsvorbereitung und ersetzen weder ärztliche Diagnostik noch aktuelle Rechtsberatung. Prüfe Version und örtliche Zuständigkeit.', style: TextStyle(fontSize: 12.5))
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
