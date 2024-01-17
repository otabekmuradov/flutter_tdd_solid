import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/usecases/usecase.dart';
import '/core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repository/number_trivia_repo.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepo repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
