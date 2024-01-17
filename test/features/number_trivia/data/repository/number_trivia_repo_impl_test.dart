import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:proj_with_reso/core/error/exceptions.dart';
import 'package:proj_with_reso/core/error/failures.dart';
import 'package:proj_with_reso/core/network/network_info.dart';
import 'package:proj_with_reso/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:proj_with_reso/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:proj_with_reso/features/number_trivia/data/models/number_trivia_dto.dart';
import 'package:proj_with_reso/features/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'package:proj_with_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'number_trivia_repo_impl_test.mocks.dart';

@GenerateMocks(
    [NetWorkInfo, NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource])
void main() {
  late final NumberTriviaRepoImpl repo;
  late final MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late final MockNumberTriviaLocalDataSource mockLocalDataSource;
  late final MockNetWorkInfo mockNetWorkInfo;

  setUpAll(
    () {
      mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
      mockLocalDataSource = MockNumberTriviaLocalDataSource();
      mockNetWorkInfo = MockNetWorkInfo();

      repo = NumberTriviaRepoImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetWorkInfo,
      );
    },
  );

  void runTestsOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(
          () {
            when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
          },
        );
        body();
      }, skip: true,
    );
  }

  void runTestsOffline(Function body) {
    group(
      'device is offline',
      () {
        setUp(
          () {
            when(mockNetWorkInfo.isConnected).thenAnswer((_) async => false);
          },
        );
        body();
      },
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      const tNumber = 1;
      final tNumberTriviaDto =
          NumberTriviaDto(number: tNumber, text: 'test trivia');
      final NumberTrivia tNumberTriviaEntity = tNumberTriviaDto;

      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repo.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNetWorkInfo.isConnected);
        },
      );

      runTestsOnline(() {
        test(
          'should return remote data when call to remote data source is successful',
          () async {
            // arange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTriviaDto);
            // act
            final result = await repo.getConcreteNumberTrivia(tNumber);
            // assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(
              result,
              Right(tNumberTriviaEntity),
            );
          },
        );

        test(
          'should cache the data locally when call to remote data source is successful',
          () async {
            // arange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTriviaDto);
            // act
            await repo.getConcreteNumberTrivia(tNumber);
            // assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaDto));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            // arange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenThrow(ServerException());
            // act
            final result = await repo.getConcreteNumberTrivia(tNumber);
            // assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(mockLocalDataSource);
            expect(
              result,
              Left(ServerFailure()),
            );
          },
        );
      });

      runTestsOffline(
        () {
          test(
            'should return locally chached data when the cached data is present',
            () async {
              // arange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaDto);
              // act
              final result = await repo.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Right(tNumberTriviaEntity)));
            },
          );

          test(
            'should return Cache failure when there is no cached data present',
            () async {
              // arange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              // act
              final result = await repo.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },skip: true,
  );

  group(
    'getRandomNumberTrivia',
    () {
      final tNumberTriviaDto =
          NumberTriviaDto(number: 123, text: 'test trivia');
      final NumberTrivia tNumberTriviaEntity = tNumberTriviaDto;

      test(
        'should check if the device is online',
        () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaDto);
          // arrange
          when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repo.getRandomNumberTrivia();
          // assert
          verify(mockNetWorkInfo.isConnected);
        },
      );

      runTestsOnline(() {
        test(
          'should return remote data when call to remote data source is successful',
          () async {
            // arange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaDto);
            // act
            final result = await repo.getRandomNumberTrivia();
            // assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            expect(
              result,
              Right(tNumberTriviaEntity),
            );
          },
        );

        test(
          'should cache the data locally when call to remote data source is successful',
          () async {
            // arange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaDto);
            // act
            await repo.getRandomNumberTrivia();
            // assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaDto));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            // arange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());
            // act
            final result = await repo.getRandomNumberTrivia();
            // assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(
              result,
              Left(ServerFailure()),
            );
          },
        );
      });

      runTestsOffline(
        () {
          test(
            'should return locally chached data when the cached data is present',
            () async {
              // arange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaDto);
              // act
              final result = await repo.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Right(tNumberTriviaEntity)));
            },skip: true,
          );

          test(
            'should return Cache failure when there is no cached data present',
            () async {
              // arange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              // act
              final result = await repo.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },skip: true,
          );
        },
      );
    },
  );
}



  // const tNumber = 1;

  // const tNumberTriviaDto =
  //     NumberTriviaDto(text: 'test trivia', number: tNumber);

  // const NumberTrivia tNumberTriviaEntity = tNumberTriviaDto;

//   void runTestOnline(Function body) {
//     group('device is Online', () {
//       setUp(() {
//         when(mockNetWorkInfo.isConnected)
//             .thenAnswer((_) async => true);
//       });
//       body();
//     }, skip: true);
//   }

//   void runTestOffline(Function body) {
//     group('device is Offline', () {
//       setUp(() {
//         when(mockNetWorkInfo.isConnected)
//             .thenAnswer((_) async => false);
//       });
//       body();
//     });
//   }

//   runTestOnline(() {
//     group(
//       'get concrete NumberTriviaEntity',
//       () {
//         group('when remote call is successful', () {
//           test('should check if the device is online', () {
//             when(mockRemoteDataSource.getConcreteNumberTrivia(any))
//                 .thenAnswer((_) async => tNumberTriviaDto);

//             //arrange
//             when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
//             // act
//             repo.getConcreteNumberTrivia(tNumber);
//             // assert
//             verify(mockNetWorkInfo.isConnected);
//           });
//           test(
//               'should return remote data when call to remote data source is successful',
//               () async {
//             //arrange
//             when(mockRemoteDataSource.getConcreteNumberTrivia(any))
//                 .thenAnswer((_) async => tNumberTriviaDto);
//             //act
//             final result = await repo.getConcreteNumberTrivia(tNumber);
//             //assert
//             verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
//             expect(result, equals(const Right(tNumberTriviaEntity)));
//           });

//           test(
//               'should store result in local data source when call to remote data source successful',
//               () async {
//             //arrange
//             when(mockRemoteDataSource.getConcreteNumberTrivia(any))
//                 .thenAnswer((_) async => tNumberTriviaDto);
//             //act
//             repo.getConcreteNumberTrivia(tNumber);
//             //assert
//             verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaDto));
//           });
//         });
//         group('when remote call is unsuccessful', () {
//           setUp(() {
//             when(mockRemoteDataSource.getConcreteNumberTrivia(any))
//                 .thenThrow(ServerException());
//           });
//           test(
//               'should return ServerFailure when call to remote data source is unsuccessful',
//               () async {
//             //arrange

//             //act
//             final result = await repo.getConcreteNumberTrivia(tNumber);
//             //assert
//             verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
//             verifyZeroInteractions(mockLocalDataSource);
//             expect(result, Left(ServerFailure()));
//           });
//         });
//       },
//     );
//     group('get random NumberTriviaEntity', () {
//       group('when remote call successful', () {
//         //should return something when something called
//         test(
//             'should check device is online  when call randomNumberTrivia invoked',
//             () async {
//           //arrange

//           //act
//           await repo.getRandomNumberTrivia();
//           //verify interactions with mockObjects
//           verify(mockNetWorkInfo.isConnected);
//           //assert
//         });

//         //should return something when something called
//         test(
//             'should store NumberTriviaEntity when call to remote data source was successful',
//             () async {
//           //arrange
//           when(mockRemoteDataSource.getRandomNumberTrivia())
//               .thenAnswer((_) async => tNumberTriviaDto);
//           //act
//           final result = await repo.getRandomNumberTrivia();
//           //verify interactions with mockObjects
//           verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaDto));
//           //assert
//         });
//         //should return something when something called
//         test(
//             'should return numberTriviaEntity when call remote data source is successful',
//             () async {
//           //arrange
//           when(mockRemoteDataSource.getRandomNumberTrivia())
//               .thenAnswer((_) async => tNumberTriviaDto);
//           //act
//           final result = await repo.getRandomNumberTrivia();
//           //verify interactions with mockObjects

//           //assert
//           expect(result, const Right(tNumberTriviaEntity));
//         });
//       });
//       group('when remote call is unsuccessful', () {
//         //should return something when something called
//         test(
//             'should check device is online  when call randomNumberTrivia invoked',
//             () async {
//           //arrange

//           //act
//           await repo.getRandomNumberTrivia();
//           //verify interactions with mockObjects
//           verify(mockNetWorkInfo.isConnected);
//           //assert
//         });

//         //should return something when something called
//         test(
//             'should return ServerFailure when call to getRandomNumberTrivia is unsuccessful',
//             () async {
//           //arrange
//           when(mockRemoteDataSource.getRandomNumberTrivia())
//               .thenThrow(ServerException());
//           //act
//           final result = await repo.getRandomNumberTrivia();

//           //verify interactions with mockObjects
//           verifyZeroInteractions(mockLocalDataSource);
//           //assert
//           expect(result, equals(Left(ServerFailure())));
//         });
//       });
//     });
//   });

//   runTestOffline(() {
//     group('when call concrete number', () {
//       test('should return last cached data when the cache data is present',
//           () async {
//         //arrange
//         when(mockLocalDataSource.getLastNumberTrivia())
//             .thenAnswer((_) async => tNumberTriviaDto);
//         //act
//         final result = await repo.getConcreteNumberTrivia(tNumber);
//         //assert
//         verifyZeroInteractions(mockRemoteDataSource);
//         verify(mockLocalDataSource.getLastNumberTrivia());
//         expect(result, equals(const Right(tNumberTriviaEntity)));
//       });
//       //should return something when something called
//       test('should return CacheFailure when no local data is present',
//           () async {
//         //arrange
//         when(mockLocalDataSource.getLastNumberTrivia())
//             .thenThrow(CacheException());
//         //act
//         final result = await repo.getConcreteNumberTrivia(tNumber);
//         //verify interactions with mockObjects
//         verifyZeroInteractions(mockRemoteDataSource);
//         verify(mockLocalDataSource.getLastNumberTrivia());
//         //assert
//         expect(result, equals(Left(CacheFailure())));
//       });
//     }, skip: true);

//     group('when call random number when device is offline', () {
//       //should return something when something called
//       test(
//           'should return numberTriviaEntity when last get stored number successfully',
//           () async {
//         //arrange
//         when(mockLocalDataSource.getLastNumberTrivia())
//             .thenAnswer((_) async => tNumberTriviaDto);
//         //act
//         final result = await repo.getRandomNumberTrivia();
//         //verify interactions with mockObjects
//         verify(mockNetWorkInfo.isConnected);

//         //assert
//         expect(result, equals(const Right(tNumberTriviaEntity)));
//       });

//       //should return something when something called
//       test(
//           'should return LocalFailure when get last stored number is unsuccessful',
//           () async {
//         //arrange
//         when(mockLocalDataSource.getLastNumberTrivia())
//             .thenThrow(CacheException());
//         //act
//         final result = await repo.getRandomNumberTrivia();
//         //verify interactions with mockObjects
//         verifyZeroInteractions(mockRemoteDataSource);
//         //assert
//         expect(result, equals(Left(CacheFailure())));
//       });
//     });
//   });
// }
