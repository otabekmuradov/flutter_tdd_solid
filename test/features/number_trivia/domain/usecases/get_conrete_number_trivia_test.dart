import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj_with_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:proj_with_reso/features/number_trivia/domain/repository/number_trivia_repo.dart';
import 'package:proj_with_reso/features/number_trivia/domain/usecases/get_conrete_number_trivia.dart';
import 'get_conrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepo])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepo mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepo();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test(
    'should get trivia for the number from repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await usecase(Params(number: tNumber));
      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
