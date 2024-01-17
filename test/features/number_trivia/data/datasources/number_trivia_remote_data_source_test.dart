import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:proj_with_reso/core/error/exceptions.dart';
import 'package:proj_with_reso/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:proj_with_reso/features/number_trivia/data/models/number_trivia_dto.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void _setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(fixture('trivia.json'), 200));
  }

  void _setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaDto =
        NumberTriviaDto.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
      being the endpoint adn with application/json''', () async {
      //arrange
      _setUpMockHttpClientSuccess200();
      //act
      remoteDataSource.getConcreteNumberTrivia(tNumber);
      //arr
      verify(
        mockHttpClient
            .get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {
          'Content-Type': 'application/json',
        }),
      );
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      //arrange
      _setUpMockHttpClientSuccess200();
      //act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
      //arr
      expect(result, tNumberTriviaDto);
    });

    test('should throw a ServerException when the response code 404 or other',
        () async {
      //arrange
      _setUpMockHttpClientFailure404();
      //act
      final call = remoteDataSource.getConcreteNumberTrivia;
      //arr
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaDto =
        NumberTriviaDto.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
          being the endpoint and with application/json''', () async {
      //arrange
      _setUpMockHttpClientSuccess200();
      //act
      remoteDataSource.getRandomNumberTrivia();
      //arr
      verify(
        mockHttpClient.get(Uri.parse('http://numbersapi.com/random'), headers: {
          'Content-Type': 'application/json',
        }),
      );
      //expect(, matcher);
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      //arrange
      _setUpMockHttpClientSuccess200();
      //act
      final result = await remoteDataSource.getRandomNumberTrivia();
      //arr
      expect(result, tNumberTriviaDto);
    });

    test('should throw a ServerException when the response code 404 or other',
        () async {
      //arrange
      _setUpMockHttpClientFailure404();
      //act
      final call = remoteDataSource.getRandomNumberTrivia;
      //arr
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
