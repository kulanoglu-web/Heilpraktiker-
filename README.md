# HP Psychotherapie Trainer (Flutter, Android)

Lern-App zur Vorbereitung auf die Heilpraktiker-Überprüfung (beschränkt auf Psychotherapie).

## Starten

Flutter muss installiert sein (https://docs.flutter.dev/get-started/install).

```bash
cd hp_psych_trainer
flutter create --platforms=android .   # erzeugt den android/-Ordner
flutter pub get
flutter run                            # Handy per USB oder Emulator
flutter build apk --release            # APK zum Installieren
```

## Funktionen

- Prüfungsprofil je Bundesland (Berlin ist Standard): Fragenzahl, Zeit, Bestehensgrenze
- Prüfungssimulation mit Zeitlimit, Punkten und Auswertung mit Erklärungen
- Übungsmodus mit sofortiger Erklärung, "Fehler wiederholen"
- Lernkarteien nach Themenbereichen (gewusst / nochmal)
- Mündliche Prüfung: Fallbeschreibung, Fragen, Musterantworten

## Inhalte erweitern

Alle Inhalte liegen als JSON in `assets/data/` (`questions.json`, `flashcards.json`,
`oral_cases.json`). Für eine volle Simulation mit 28 Fragen mindestens 28 Fragen
eintragen (aktuell 348).

Frageformat:

```json
{"id":"q69","topic":"Sucht","kind":"combo","text":"...","options":["A","B","C","D","E"],"correct":2,"explanation":"..."}
// Mehrfachauswahl: "correct":[0,3]
```

## Hinweise

- Die Beispielinhalte sind eigene Formulierungen. Sie ersetzen keine Prüfungsliteratur.
- Original-Prüfungsfragen aus Büchern, Kursen oder Foren sind urheberrechtlich
  geschützt und dürfen nicht ohne Erlaubnis in die App kopiert werden.
- Verbindliche Prüfungsregeln (Dauer, Termine) gibt das zuständige Gesundheitsamt vor.
