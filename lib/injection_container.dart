import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'core/util/input_conversion.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'features/number_trivia/domain/repository/number_trivia_repo.dart';
import 'features/number_trivia/domain/usecases/get_conrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

// final ls = GetIt.instance;

// Future<void> setup() async {
//   // FEATURES - NUMBER TRIVIA

//   //! Bloc

//   ls.registerFactory(
//     () => NumberTriviaBloc(
//       concrete: ls(),
//       random: ls(),
//       inputConverter: ls(),
//     ),
//   );

//   //! Use Cases

//   ls.registerLazySingleton(
//     () => GetConcreteNumberTrivia(
//       ls(),
//     ),
//   );
//   ls.registerLazySingleton(
//     () => GetRandomNumberTrivia(
//       ls(),
//     ),
//   );

//   //! Repository

//   ls.registerLazySingleton<NumberTriviaRepo>(
//     () => NumberTriviaRepoImpl(
//       remoteDataSource: ls(),
//       localDataSource: ls(),
//       networkInfo: ls(),
//     ),
//   );

//   //! Data sources

//   ls.registerLazySingleton<NumberTriviaLocalDataSource>(
//     () => NumberTriviaLocalDataSourceImpl(
//       sharedPreferences: ls(),
//     ),
//   );

//   ls.registerLazySingleton<NumberTriviaRemoteDataSource>(
//     () => NumberTriviaRemoteDataSourceImpl(
//       client: ls(),
//     ),
//   );

//   //! CORE

//   ls.registerLazySingleton(() => InputConverter());

//   ls.registerLazySingleton<NetWorkInfo>(
//     () => NetWorkInfoImpl(
//       ls(),
//     ),
//   );

//   //! EXTERNAL

//   final prefs = await SharedPreferences.getInstance();
//   ls.registerLazySingleton<SharedPreferences>(() => prefs);

//   ls.registerLazySingleton(() => http.Client);

//   ls.registerLazySingleton(() => DataConnectionChecker());
// }


final ls = GetIt.instance;

/*
  Factory: always instantiate a new instance of the given class
  whenever we request.

  Singleton: always (after the first time) get the same instance,
  get_it will cache it and then on subsequent calls to it 
  througout the lifetime of the app it's going to give out the same instance 
  and not instantiate a new one since it's a single thing.

  -) Presentation logic holders such as BloC shouldn't be registered as 
  singleton, because they are very close to the UI. 
  For example the app has multiple pages between which you can navigate, 
  you probably do not want this to be a singleton 
  because you wanna do some cleanup like closing steams and 
  all of that from the dispose method of a widget.

  -) Trying to close a stream but having a singleton will lead to problems,
  because you would close a stream but if you were to come back
  to the previous page on which that BloC is being used and 
  you would try to get an instance from get_it of this number trivia BloC
  for example, and this was a singleton and not a factory, you would get
  the same instance of number trivia BloC as previously 
  which now has a closed stream.

  *: Whenever you do some disposal logic you should always register Factory
  and not a singleton because then you are going to get the same instance
  with the close stream or close dispose whatever else and 
  that's gonna cause some problem
*/

Future<void> setup() async {
  //! Features - Number Trivia
  // Bloc
  ls.registerFactory(
    () => NumberTriviaBloc(
      concrete: ls(),
      random: ls(),
      inputConverter: ls(),
    ),
  );

  // Use cases (do not depend on implementation but on contract)
  // Singleton: always registered immediately after the app start
  // LazySingleton: registered only when it is requested
  // as dependency for some other class
  ls
      .registerLazySingleton(() => GetConcreteNumberTrivia(ls()));
  ls
      .registerLazySingleton(() => GetRandomNumberTrivia(ls()));

  // Repository (Generic Contract)
  ls.registerLazySingleton<NumberTriviaRepo>(
    () => NumberTriviaRepoImpl(
      remoteDataSource: ls(),
      localDataSource: ls(),
      networkInfo: ls(),
    ),
  );

  // Data sources
  ls.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: ls()),
  );
  ls.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: ls()),
  );

  //! Core
  ls.registerLazySingleton(() => InputConverter());
  ls.registerLazySingleton<NetWorkInfo>(
    () => NetWorkInfoImpl(ls()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  ls.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
  ls.registerLazySingleton(() => http.Client());
  ls.registerLazySingleton(() => DataConnectionChecker());
}