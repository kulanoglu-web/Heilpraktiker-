import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hp_psych_trainer/catalog.dart';
import 'package:hp_psych_trainer/catalog_models.dart';
import 'package:hp_psych_trainer/models.dart';
import 'package:hp_psych_trainer/quiz.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('search, reveal, mark and hide learned cards', (tester) async {
    final cards = [
      const Flashcard(
        id: 'test_1',
        topic: 'Organisch',
        front: 'Was ist ein Delir?',
        back: 'Akute Verwirrtheit.',
      ),
      const Flashcard(
        id: 'test_2',
        topic: 'Sucht',
        front: 'Was ist Craving?',
        back: 'Starkes Verlangen.',
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: CatalogStudyScreen(title: 'Wissen', cards: cards),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Akute Verwirrtheit.'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Delir');
    await tester.pumpAndSettle();
    expect(find.text('Was ist Craving?'), findsNothing);
    await tester.tap(find.text('Antwort zeigen'));
    await tester.pumpAndSettle();
    expect(find.text('Akute Verwirrtheit.'), findsOneWidget);
    await tester.tap(find.text('Gelernt'));
    await tester.pumpAndSettle();
    expect(await Progress.ids(Progress.knownKey), contains('test_1'));
    await tester.tap(find.text('Nur offene Fragen'));
    await tester.pumpAndSettle();
    expect(find.text('Keine passenden offenen Fragen.'), findsOneWidget);
  });

  testWidgets('fixed exam defers solutions and scores 21 of 28 as passed', (
    tester,
  ) async {
    final q = List.generate(
      28,
      (i) => Question(
        id: 'paper_$i',
        topic: 'Grundlagen',
        text: 'Aufgabe ${i + 1}',
        options: const ['Richtig', 'Falsch'],
        correctSet: const [0],
        explanation: 'Nur nach Abgabe sichtbar.',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: QuizScreen(
          profile: catalogExamProfile,
          questions: q,
          examMode: true,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('60:00'), findsOneWidget);
    expect(find.text('Nur nach Abgabe sichtbar.'), findsNothing);
    for (var i = 0; i < 28; i++) {
      await tester.tap(find.text(i < 21 ? 'Richtig' : 'Falsch'));
      await tester.pump();
      await tester.tap(find.text(i == 27 ? 'Auswerten' : 'Weiter').last);
      await tester.pumpAndSettle();
    }
    expect(find.byType(ResultScreen), findsOneWidget);
    expect((await Progress.history()).single, contains('|21|28'));
    expect(find.textContaining('Bestanden'), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('catalog loads on a small screen with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.3)),
          child: child!,
        ),
        home: CatalogScreen(profile: examProfiles.first),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('272 Fragen mit Antworten'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
