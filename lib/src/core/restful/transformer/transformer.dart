import 'dart:async';

import 'package:cg_core_defs/strategies/cache/cache_manager.dart';
import 'package:dio/dio.dart' show RequestOptions, ResponseBody;

import '../../../models/data_objects.dart';
import 'definition/response_transformation_strategy.dart';
import 'definition/strategy_based_transformer.dart';
import 'strategies/cached_response_strategy.dart';
import 'strategies/mocked_response_strategy.dart';
import 'strategies/network_response_strategy.dart';

final class LeanTransformer<R, M extends DAO> extends StrategyBasedTransformer<R> {
  final TransformerRequirements<M> requirements;
  final CacheManager cacheManager;
  final String cachingKey;
  final dynamic mockingData;
  final int mockAwaitTime;

  LeanTransformer({
    required this.requirements,
    required this.cacheManager,
    required this.cachingKey,
    required this.mockingData,
    required this.mockAwaitTime,
  });

  late final _cacheStrategy = CachedResponseTransformationStrategy<R, M>(
    requirements,
    cacheManager: cacheManager,
    cachingKey: cachingKey,
  );

  late final _mockStrategy = MockedResponseTransformationStrategy<R, M>(
    requirements,
    mockAwaitTime: mockAwaitTime,
    mockingData: mockingData,
  );

  late final _networkStrategy = NetworkResponseTransformationStrategy<R, M>(
    requirements,
    cacheManager: cacheManager,
    cachingKey: cachingKey,
  );

  @override
  Future<R> transformCachedResponse() async => await _cacheStrategy.transform();

  @override
  Future<R> transformMockedResponse() async => await _mockStrategy.transform();

  @override
  Future<R> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async =>
      await _networkStrategy.transform(
        data: await super.transformResponse(options, responseBody),
        responseBody: responseBody,
      );
}
