import 'package:cg_core_defs/cg_core_defs.dart';

class UnsupportedDataTypeException implements Exception {
  UnsupportedDataTypeException() {
    Debugger.red('Unsupported data type encountered during decoding.');
  }
}

final class DataDecodingException<M> implements Exception {
  DataDecodingException(dynamic exception, StackTrace stacktrace) {
    Debugger.red("$M $exception\n$stacktrace");
  }
}

final class MissingListKeyException implements Exception {
  MissingListKeyException() {
    Debugger.red("Received response is a Map, you have not specified a `listKey` though, you should be trying to anger me.");
  }
}

final class UnawaitedListKeyException implements Exception {
  UnawaitedListKeyException(listKey) {
    Debugger.yellow(
        " You have specified [$listKey] as the List key, but received response is a list, you should be trying to fool me..");
  }
}

final class MockingDataDecodingException<M> implements Exception {
  MockingDataDecodingException(dynamic exception, StackTrace stacktrace) {
    Debugger.red("$M $exception\n$stacktrace");
  }
}

final class ServerException implements Exception {}

final class CacheException implements Exception {}
