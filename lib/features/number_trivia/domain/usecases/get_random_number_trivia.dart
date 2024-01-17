import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repository/number_trivia_repo.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepo repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}