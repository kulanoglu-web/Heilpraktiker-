# HP Psychotherapie Trainer

Flutter-App zur Vorbereitung auf die Heilpraktiker-Überprüfung, beschränkt auf Psychotherapie.

## Lernbereiche

- **Lernkatalog mit 272 Fragen:** 77 Wissensfragen in zehn Kapiteln, 15 mündliche Fallübungen, eine feste Probeprüfung mit 28 Fragen und 152 zusätzliche Vertiefungsfragen.
- Wissen durchsuchen, Antworten aufdecken, Gelerntes speichern, offene Fragen wiederholen und Kapitel als Lernkarten bearbeiten.
- Feste Probeprüfung: 28 Fragen, 60 Minuten, mindestens 21 vollständig richtige Antworten. Lösungen werden im Prüfungsmodus erst nach Abgabe gezeigt; separate Lösungsliste zum Nacharbeiten.
- Vertiefung mit Suche, Themenfilter und zufälligen Übungssätzen mit bis zu 20 Fragen.
- Prüfungsrahmen und Übersicht aller 16 Bundesländer, regionale Fallübungen und gesammelte Quellen mit anklickbaren Original-PDFs.
- **Gesamtbestand: 714 Auswahlfragen, 472 Lernkarten, 90 mündliche Fälle.** Bestehende Inhalte und Fortschritts-IDs bleiben erhalten.
- Allgemeine Prüfungssimulation mit Themenmix, Fehlerwiederholung, Erklärungen und Themenstatistik.
- Gespeichertes Bundeslandprofil; Berlin als Standard. 60 Minuten sind die Trainingsvorgabe. Abweichende Amtsvorgaben bleiben verbindlich.
- Hell- und Dunkelmodus; Lernstand ausschließlich lokal auf dem Gerät.

## Inhalte und Recherche

`assets/data/learning_catalog.json` ordnet den Katalog den vorhandenen Fragen-, Karten- und Falldateien zu. Die 120 Kernfragen entsprechen der bereitgestellten PDF vom 11.11.2026. Weitere 152 Fragen wurden zu Themen von 38 eingesehenen schriftlichen Bögen aus 2006 bis 2026 eigenständig formuliert. Die Zuordnung der Vertiefungsfragen zu den Quellen steht in `research/content_sources.json`; die Quellen sind gesammelt in der App erreichbar. Einzelne Fragen tragen keine Herkunftskennzeichnungen.

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
