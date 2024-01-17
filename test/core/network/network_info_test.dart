import "package:data_connection_checker_nulls/data_connection_checker_nulls.dart";
import "package:mockito/annotations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:proj_with_reso/core/network/network_info.dart";

import "network_info_test.mocks.dart";

@GenerateMocks([DataConnectionChecker])
void main() {
  late MockDataConnectionChecker dataConnectionChecker;
  late NetWorkInfoImpl netWorkInfoImpl;

  setUp(() {
    dataConnectionChecker = MockDataConnectionChecker();
    netWorkInfoImpl = NetWorkInfoImpl(dataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection ',
        () async {
      //arrange
      final tHasConnectionFuture = Future.value(true);

      when(dataConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) => tHasConnectionFuture);
      //act
      final result = netWorkInfoImpl.isConnected;
      //assert
      verify(dataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
