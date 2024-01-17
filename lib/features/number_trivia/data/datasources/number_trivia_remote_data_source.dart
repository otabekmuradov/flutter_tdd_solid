import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proj_with_reso/core/error/exceptions.dart';
import '../models/number_trivia_dto.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaDto> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaDto> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaDto> getConcreteNumberTrivia(int number)  =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaDto> getRandomNumberTrivia()  =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaDto> _getTriviaFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaDto.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
  
}
