import 'dart:convert';

import 'package:proj_with_reso/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_dto.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaDto] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaDto> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaDto triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaDto> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(
        NumberTriviaDto.fromJson(
          jsonDecode(jsonString),
        ),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaDto triviaToCache) {
    final jsonString = jsonEncode(triviaToCache.toJson());
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }
}
