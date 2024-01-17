import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepo {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}