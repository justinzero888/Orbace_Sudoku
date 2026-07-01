// Coverage for the "Paste" tab of the puzzle importer
// (ImportedPuzzleService.previewFromString), which parses an 81-cell puzzle
// string, validates it, and rates its difficulty.
//
// 15 valid strings spanning all six difficulty tiers plus 5 invalid strings
// covering distinct failure modes. The valid strings for beginner/easy/
// medium/hard/expert were produced by SudokuGenerator (the app's own puzzle
// generator) so they're guaranteed solvable and internally consistent; the
// extreme-tier strings were built by stripping a solved grid down to a
// near-minimal, uniquely-solvable set of givens that exceeds the app's
// human-technique set (naked/hidden single, naked/hidden pair, pointing
// pair), which is exactly the "extreme" fallback path in
// ImportedPuzzleService. See scripts used to derive these values in the PR
// description; the strings themselves are pinned here for deterministic
// tests.
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/app_database.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/imported_puzzle_service.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/sudoku_repository.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';

void main() {
  group('ImportedPuzzleService.previewFromString', () {
    late AppDatabase database;
    late SudokuRepository repository;
    late ImportedPuzzleService service;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = SudokuRepository(database);
      service = ImportedPuzzleService(repository: repository);
    });

    tearDown(() async {
      await database.close();
    });

    group('valid puzzle strings', () {
      const cases = <String, MapEntry<String, SudokuDifficulty>>{
        'beginner #1': MapEntry(
          '091605040006082913000139067075018396180060754009007800040091035000024109018356472',
          SudokuDifficulty.beginner,
        ),
        'beginner #2': MapEntry(
          '060000089000700504400001670680300241573002090124060735796003418235084060041009050',
          SudokuDifficulty.beginner,
        ),
        'beginner #3': MapEntry(
          '000506201027030060006007083060703090003009012000021704010085926090170058035060147',
          SudokuDifficulty.beginner,
        ),
        'easy #1': MapEntry(
          '005708000630000007002010900050097000010060700729100400204000506060000078107630209',
          SudokuDifficulty.easy,
        ),
        'easy #2': MapEntry(
          '000039820081500000900180600098600003573000206006000040000208007000000402000710039',
          SudokuDifficulty.easy,
        ),
        'easy #3': MapEntry(
          '940108050006075000000900601230049800090700002010000400000000005000007324571000000',
          SudokuDifficulty.easy,
        ),
        'medium #1': MapEntry(
          '020400100004016803105000000400000090082700400300601000008003001000070008041800230',
          SudokuDifficulty.medium,
        ),
        'medium #2': MapEntry(
          '800045010010006005000900000009000430400000750050002000680000000020304081304000000',
          SudokuDifficulty.medium,
        ),
        'medium #3': MapEntry(
          '000009500000000401250013008002000000080024003700000600124008905000000214600000080',
          SudokuDifficulty.medium,
        ),
        'hard #1': MapEntry(
          '000693001000000009300005020000060750080009006063007900831000000000008270000040000',
          SudokuDifficulty.hard,
        ),
        'hard #2': MapEntry(
          '020500100500890020000307000070000000003000804008913000000102050030000906050000001',
          SudokuDifficulty.hard,
        ),
        'expert #1': MapEntry(
          '765080001014075000000000000000200517400000000000006032000900084007008100300002609',
          SudokuDifficulty.expert,
        ),
        'expert #2': MapEntry(
          '000000004075031060000060700000000850000100000001243000000024008006800510090000000',
          SudokuDifficulty.expert,
        ),
        'extreme #1 (exceeds human technique set)': MapEntry(
          '007006009030400000000300057000040810002000600700820000008003006406900000070100000',
          SudokuDifficulty.extreme,
        ),
        'extreme #2 (exceeds human technique set)': MapEntry(
          '020000040016052000003400070050000000200000014104006008080000050570018062002000800',
          SudokuDifficulty.extreme,
        ),
      };

      for (final entry in cases.entries) {
        test('accepts and rates ${entry.key}', () async {
          final puzzleString = entry.value.key;
          final expectedDifficulty = entry.value.value;

          final preview = await service.previewFromString(
            puzzleString,
            title: entry.key,
          );

          expect(preview.difficulty, expectedDifficulty);
          expect(preview.givens.cells.whereType<int>().length, greaterThanOrEqualTo(17));
          expect(preview.solution.cells.whereType<int>().length, 81);
        });
      }
    });

    group('invalid puzzle strings', () {
      test('rejects a string missing a cell (wrong length)', () async {
        // 80 characters - one digit short of the required 81.
        const missingCell =
            '09160504000608291300013906707501839618006075400900780004009103500002410901835647';
        expect(missingCell.length, 80);

        await expectLater(
          service.previewFromString(missingCell),
          throwsA(
            isA<ImportedPuzzleException>().having(
              (error) => error.message,
              'message',
              contains('exactly 81 cells'),
            ),
          ),
        );
      });

      test('rejects a string with a non-digit character', () async {
        const invalidCharacter =
            'a91605040006082913000139067075018396180060754009007800040091035000024109018356472';
        expect(invalidCharacter.length, 81);

        await expectLater(
          service.previewFromString(invalidCharacter),
          throwsA(
            isA<ImportedPuzzleException>().having(
              (error) => error.message,
              'message',
              contains('digits 1-9'),
            ),
          ),
        );
      });

      test('rejects a puzzle with fewer than 17 givens', () async {
        const tooFewGivens =
            '100000000020000000003000000000400000000050000000006000000000700000000080000000009';
        // Only 9 non-zero cells.
        expect(
          tooFewGivens.split('').where((c) => c != '0').length,
          9,
        );

        await expectLater(
          service.previewFromString(tooFewGivens),
          throwsA(
            isA<ImportedPuzzleException>().having(
              (error) => error.message,
              'message',
              contains('at least 17 givens'),
            ),
          ),
        );
      });

      test('rejects a puzzle with a duplicate given in the same row', () async {
        // Same as the beginner #1 grid above, but the first two cells of
        // row 0 are both forced to '5'.
        const conflictingGivens =
            '551605040006082913000139067075018396180060754009007800040091035000024109018356472';

        await expectLater(
          service.previewFromString(conflictingGivens),
          throwsA(
            isA<ImportedPuzzleException>().having(
              (error) => error.message,
              'message',
              contains('conflicting givens'),
            ),
          ),
        );
      });

      test('rejects a puzzle with more than one solution', () async {
        // 17 givens sliced out of a valid completed grid, scattered rather
        // than laid out as a designed unique-solution puzzle. Verified
        // out-of-band to have multiple completions.
        const multipleSolutions =
            '100050000400080000700020000200060000500090000800030000300070000600010000900000000';

        await expectLater(
          service.previewFromString(multipleSolutions),
          throwsA(
            isA<ImportedPuzzleException>().having(
              (error) => error.message,
              'message',
              contains('more than one solution'),
            ),
          ),
        );
      });
    });
  });
}
