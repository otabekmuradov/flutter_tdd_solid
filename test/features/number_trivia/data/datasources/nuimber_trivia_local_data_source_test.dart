import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:proj_with_reso/core/error/exceptions.dart";
import "package:proj_with_reso/features/number_trivia/data/datasources/number_trivia_local_data_source.dart";
import "package:proj_with_reso/features/number_trivia/data/models/number_trivia_dto.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../../../fixtures/fixture_reader.dart";
import "nuimber_trivia_local_data_source_test.mocks.dart";

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaDto =
        NumberTriviaDto.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTriviaDto from SharedPreferences whre there is one in the cache',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenAnswer((_) => fixture('trivia_cached.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaDto);
    });
    test('should throw ChacheException when there is no cached value',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    final tNumberTriviaDto = NumberTriviaDto(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', () async {
      //arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaDto);
      //assert
      //final expectedJsonString = json.encode(tNumberTriviaDto.toJson());
      final jsonString = jsonEncode(tNumberTriviaDto.toJson());
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString));
    });
  });
}
