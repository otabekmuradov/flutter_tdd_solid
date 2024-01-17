import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

abstract class NetWorkInfo {
  Future<bool> get isConnected;
}

class NetWorkInfoImpl implements NetWorkInfo {
  final DataConnectionChecker connectionChecker;

  NetWorkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
