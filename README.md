# HP Psychotherapie Trainer

Flutter-App zur Vorbereitung auf die Heilpraktiker-Überprüfung, beschränkt auf Psychotherapie.

## Lernbereiche

- **Lernkatalog mit 422 Fragen:** 117 Wissensfragen in 14 Kapiteln, 25 mündliche Fallübungen, eine feste Probeprüfung mit 28 Fragen und 232 zusätzliche Vertiefungsfragen.
- Wissen durchsuchen, Antworten aufdecken, Gelerntes speichern, offene Fragen wiederholen und Kapitel als Lernkarten bearbeiten.
- Feste Probeprüfung: 28 Fragen, 60 Minuten, mindestens 21 vollständig richtige Antworten. Lösungen werden im Prüfungsmodus erst nach Abgabe gezeigt; separate Lösungsliste zum Nacharbeiten.
- Vertiefung mit Suche, Themenfilter und zufälligen Übungssätzen mit bis zu 20 Fragen.
- Prüfungsrahmen und Übersicht aller 16 Bundesländer, regionale Fallübungen ohne externe Verlinkungen.
- **Gesamtbestand: 794 Auswahlfragen, 512 Lernkarten, 100 mündliche Fälle.** Bestehende Inhalte und Fortschritts-IDs bleiben erhalten.
- Allgemeine Prüfungssimulation mit Themenmix, Fehlerwiederholung, Erklärungen und Themenstatistik.
- Gespeichertes Bundeslandprofil; Berlin als Standard. 60 Minuten sind die Trainingsvorgabe. Abweichende Amtsvorgaben bleiben verbindlich.
- Hell- und Dunkelmodus; Lernstand ausschließlich lokal auf dem Gerät.

## Inhalte und Recherche

`assets/data/learning_catalog.json` ordnet den Katalog den vorhandenen Fragen-, Karten- und Falldateien zu. Die 120 Kernfragen entsprechen der bereitgestellten PDF vom 11.11.2026. Weitere 152 Fragen wurden zu Themen von 38 eingesehenen schriftlichen Bögen aus 2006 bis 2026 eigenständig formuliert. Die Zuordnung der Vertiefungsfragen zu den Quellen steht in `research/content_sources.json`; die Quellenzuordnung ist ausschließlich im Rechercheordner des Repositories hinterlegt und wird nicht mit der App ausgeliefert. Die App enthält keine Quellenansicht, Links, Browseraufrufe oder Laufzeit-Netzwerkfunktionen.

Die Sammlung ist kein vollständiger amtlicher Originalfragenbestand. Regionale Gedächtnisprotokolle sind subjektive Erinnerungen und belegen keine festen Landesschwerpunkte. Für Bremen wurde kein mündliches Einzelprotokoll ausgewertet. Antworten sind redaktionelle Lernantworten; ältere Rechts- und Klassifikationsangaben dürfen nicht ungeprüft übernommen werden.

## Entwicklung

```bash
flutter create --platforms=android --project-name hp_psych_trainer --org de.hptrainer .
flutter pub get
flutter analyze lib test/catalog_test.dart test/catalog_widget_test.dart --no-fatal-infos --no-fatal-warnings
flutter test test/catalog_test.dart test/catalog_widget_test.dart
flutter run
flutter build apk --release
```

GitHub Actions prüft die Anwendung vor dem APK-Build und veröffentlicht auf `main` die installierbare APK. Der vorhandene Signaturschlüssel und die Android-Anwendungskennung bleiben erhalten, damit Updates ohne absichtlichen Datenverlust installierbar bleiben.

## Datenformate

- `questions.json`: Auswahlfragen; `correct` ist ein Index oder eine Liste von Indizes. Mehrfachauswahl zählt nur vollständig richtig.
- `flashcards.json`: Lernkarten mit `front`, `back`, `topic` und stabiler `id`.
- `oral_cases.json`: Fälle mit `vignette` und Fragen-/Antwortpaaren.
- `learning_catalog.json`: Kapitel, Fragenreferenzen, Bundesländer und Quellen.

Die Tests prüfen Datenintegrität, Antwortzuordnung beim Mischen, Katalogreferenzen, Fortschrittsspeicherung, Suche, Antwortanzeige, Prüfungsauswertung und kleine Bildschirmgrößen.

## Erweiterung vom 12.11.2026

80 zusätzliche Auswahlfragen (je 40 pro Thema), 40 Lernkarten und 10 Fälle mit 30 mündlichen Fragen behandeln Psychopharmaka sowie somatische Differenzialdiagnostik. Eigene Themenfilter und vier Lernkapitel erschließen die Inhalte. Medikamentenrisiken, Warnzeichen und sichere ärztliche Weitervermittlung stehen im Vordergrund; keine eigenständigen Verordnungs- oder Dosieranweisungen.

`ci/verify_offline.py` überprüft Code und ausgelieferte Daten auf externe Ziele und entfernt Netzwerkberechtigungen aus erzeugten Manifesten. Vor Veröffentlichung wird zusätzlich das zusammengeführte Manifest der Release-APK geprüft. Die App benötigt nach Installation keine Internetverbindung.
