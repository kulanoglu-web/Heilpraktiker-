import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hp_psych_trainer/catalog_models.dart';
import 'package:hp_psych_trainer/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all content IDs and answer indexes are valid', () async {
    for (final name in ['questions', 'flashcards', 'oral_cases']) {
      final items = jsonDecode(
        await rootBundle.loadString('assets/data/$name.json'),
      ) as List;
      final ids = <String>{};
      for (final item in items) {
        expect(
          ids.add(item['id'] as String),
          isTrue,
          reason: 'Duplicate: ${item['id']}',
        );
        if (name == 'questions') {
          final options = item['options'] as List;
          final raw = item['correct'];
          final correct = raw is List ? raw.cast<int>() : [raw as int];
          expect(options.length, greaterThanOrEqualTo(2));
          expect(correct, isNotEmpty);
          expect(correct.toSet().length, correct.length);
          for (final index in correct) {
            expect(index, inInclusiveRange(0, options.length - 1));
          }
          expect(item['explanation'], isNotEmpty);
        }
      }
    }
  });

  test(
    'shuffling retains correct answer indexes even with identical labels',
    () {
      final raw = <String, dynamic>{
        'id': 'duplicate-labels',
        'topic': 'Test',
        'text': 'Index test',
        'options': ['same', 'same', 'other'],
        'correct': [0, 1],
        'explanation': 'Test',
      };
      for (var i = 0; i < 30; i++) {
        final q = Question.fromJson(raw);
        expect(q.correctSet.toSet().length, 2);
        expect(q.correctSet.map((i) => q.options[i]), everyElement('same'));
        expect(q.isCorrect(q.correctSet.toSet()), isTrue);
        expect(q.isCorrect({q.correctSet.first}), isFalse);
      }
    },
  );

  test('catalog resolves the expanded offline learning sections', () async {
    final c = await loadLearningCatalog();
    expect(c.chapters.length, 14);
    expect(c.cards.length, 117);
    expect(c.oralCases.length, 25);
    expect(c.examQuestions.length, 28);
    expect(c.questionCount, 190);
    expect(c.extraQuestions.length, 232);
    expect(c.totalQuestionCount, 422);
    expect(c.regions.length, 16);
    expect(c.regions.map((r) => r.id).toSet().length, 16);
    expect(c.regions.where((r) => r.oralCase != null).length, 15);
    expect(catalogExamProfile.minutes, 60);
    expect(catalogExamProfile.passCount, 21);
    expect(c.examQuestions.where((q) => q.isMulti), isNotEmpty);
  });

  test('existing content remains alongside the additions', () async {
    expect((await loadQuestions()).length, 794);
    expect((await loadFlashcards()).length, 512);
    expect((await loadOralCases()).length, 100);
  });

  test('medical modules contain 80 MC questions, 40 cards and 10 cases', () async {
    final qs = (await loadQuestions()).where((q) => q.id.startsWith('med26_')).toList();
    expect(qs.length, 80);
    expect(qs.where((q) => q.topic == 'Psychopharmaka').length, 40);
    expect(qs.where((q) => q.topic == 'Somatische Differenzialdiagnostik').length, 40);
    expect(qs.where((q) => q.isMulti).length, greaterThanOrEqualTo(8));
    expect((await loadFlashcards()).where((q) => q.id.startsWith('med26_')).length, 40);
    final cases = (await loadOralCases()).where((q) => q.id.startsWith('med26_')).toList();
    expect(cases.length, 10);
    expect(cases.every((q) => q.questions.length == 3), isTrue);
    expect(examTopicWeights.keys, contains('Psychopharmaka'));
    expect(examTopicWeights.keys, contains('Somatische Differenzialdiagnostik'));
  });

  test('all state profiles and selected profile persist', () async {
    SharedPreferences.setMockInitialValues({});
    expect(examProfiles.length, 16);
    expect(examProfiles.map((p) => p.id).toSet().length, 16);
    expect((await Progress.selectedProfile()).id, 'be');
    final state = examProfiles.firstWhere((p) => p.id == 'mv');
    await Progress.selectProfile(state);
    expect((await Progress.selectedProfile()).id, 'mv');
    await Progress.addAll(Progress.knownKey, ['catalog_card_001', 'f01']);
    await Progress.removeAll(Progress.knownKey, ['catalog_card_001']);
    expect(await Progress.ids(Progress.knownKey), {'f01'});
  });

  test('fixed paper uses exact marking and selected set is unique', () async {
    final c = await loadLearningCatalog();
    final answers = c.examQuestions.map((q) => q.correctSet.toSet()).toList();
    final score = List.generate(
      28,
      (i) => c.examQuestions[i].isCorrect(answers[i]),
    ).where((ok) => ok).length;
    expect(score, 28);
    final multi = c.examQuestions.firstWhere((q) => q.isMulti);
    expect(multi.isCorrect({multi.correctSet.first}), isFalse);
    final set = buildExamSet(await loadQuestions(), 28);
    expect(set.length, 28);
    expect(set.map((q) => q.id).toSet().length, 28);
    expect(set.where((q) => q.crit).length, greaterThanOrEqualTo(5));
  });
}
