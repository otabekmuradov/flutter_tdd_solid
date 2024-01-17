import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:proj_with_reso/core/error/failures.dart';
import 'package:proj_with_reso/core/usecases/usecase.dart';
import 'package:proj_with_reso/core/util/input_conversion.dart';
import 'package:proj_with_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:proj_with_reso/features/number_trivia/domain/usecases/get_conrete_number_trivia.dart';
import 'package:proj_with_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:proj_with_reso/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

import 'number_trivia_test_bloc.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
  NumberTriviaBloc
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  late MockGetRandomNumberTrivia getRandomNumberTrivia;
  late MockInputConverter inputConverter;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: getConcreteNumberTrivia,
      random: getRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initialState should be Empty', () {
    //assert
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tnumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(inputConverter.stringToInt(any)).thenReturn(Right(tNumberParsed));

    test(
        'should call the inputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(GetTriviaForConcreteNumber(tnumberString));
      await untilCalled(inputConverter.stringToInt(any));
      //assert
      verify(inputConverter.stringToInt(tnumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(inputConverter.stringToInt(any))
          .thenReturn(Left(InvalidInputFailure()));
      //assert later
      final expected = [
        Empty(),
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tnumberString));
    });

    test('should get data from the concrete usecase', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumber(tnumberString));
      await untilCalled(getConcreteNumberTrivia(any));
      //assert
      verify(getConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tnumberString));
    });

    test('should emit [Loading, Error] when data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tnumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when the data getting fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tnumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random usecase', () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(getRandomNumberTrivia(any));
      //assert
      verify(getRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange

      when(getRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when data fails', () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when the data getting fails',
        () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
