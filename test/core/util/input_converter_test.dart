import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj_with_reso/core/util/input_conversion.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      // arrange
      final str = '123';
      //act
      final result = inputConverter.stringToInt(str);
      //assert
      expect(result, Right(123));
    });

    test(
        'should return a Failure when the string is not an integer',
        () async {
      // arrange
      final str = 'abc'; // 1.0
      //act
      final result = inputConverter.stringToInt(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should return a Failure when the string is a negative integer',
        () async {
      // arrange
      final str = '-123'; // -1.0
      //act
      final result = inputConverter.stringToInt(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
