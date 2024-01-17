import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:proj_with_reso/features/number_trivia/data/models/number_trivia_dto.dart';
import 'package:proj_with_reso/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaDto = NumberTriviaDto(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaDto, isA<NumberTrivia>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia.json'),
          );
          // act
          final result = NumberTriviaDto.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaDto);
        },
      );

      test(
        'should return a valid model when the JSON number is regarded as a double',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia_double.json'),
          );
          // act
          final result = NumberTriviaDto.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaDto);
        },
      );
    },
  );

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tNumberTriviaDto.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
