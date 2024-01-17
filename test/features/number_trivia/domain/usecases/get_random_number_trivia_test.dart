import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj_with_reso/core/usecases/usecase.dart';
import 'package:proj_with_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:proj_with_reso/features/number_trivia/domain/repository/number_trivia_repo.dart';
import 'package:proj_with_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'get_conrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepo])
void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepo mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepo();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test(
    'should get trivia for the number from repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
