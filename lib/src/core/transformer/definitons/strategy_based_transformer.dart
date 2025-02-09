import 'package:dio/dio.dart' show BackgroundTransformer;

abstract class StrategyBasedTransformer<R> extends BackgroundTransformer {
  Future<R> transformCachedResponse();
  Future<R> transformMockedResponse();
}
