import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj_with_reso/core/error/failures.dart';
import 'package:proj_with_reso/core/usecases/usecase.dart';
import 'package:proj_with_reso/core/util/input_conversion.dart';
import 'package:proj_with_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:proj_with_reso/features/number_trivia/domain/usecases/get_conrete_number_trivia.dart';
import 'package:proj_with_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

// ignore: constant_identifier_names
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
// ignore: constant_identifier_names
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
// ignore: constant_identifier_names
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    /*
      async gives you a Future
      async* gives you a Stream.
    */
    // on<NumberTriviaEvent>((event, emit) {
    //   if (event is GetTriviaForConcreteNumber) {
    //     final inputEither =
    //         inputConverter.stringToUnsignedInteger(event.numberString);
    //     /* yield:
    //       adds a value to the output stream of the surrounding async* function.
    //       It's like returning value but doesn't terminate the function
    //     */
    //     inputEither.fold((failure) async* {
    //       yield const Error(message: INVALID_INPUT_FAILURE_MESSAGE);
    //     }, (integer) => throw UnimplementedError());
    //   }
    // });

    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  void _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = inputConverter.stringToInt(event.number);

    await inputEither.fold(
      (failure) async =>
          emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
      (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        _eitherLoadedOrErrorState(failureOrTrivia, emit);
      },
    );
  }

  void _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }

  void _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
    Emitter<NumberTriviaState> emit,
  ) {
    failureOrTrivia.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
