import 'dart:convert' show jsonDecode;

import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:dio/dio.dart' show ResponseBody;
import 'package:flutter/foundation.dart' show compute;

import '../../../../errors/index.dart' show NonExistingCacheDataException;
import '../../../../models/data_objects.dart';
import '../definition/response_transformation_strategy.dart';

class CachedResponseTransformationStrategy<R, M extends DAO> extends ResponseTransformationStrategy<R, M> {
  final CacheManager cacheManager;
  final String cachingKey;

  const CachedResponseTransformationStrategy(
    super.requirements, {
    required this.cacheManager,
    required this.cachingKey,
  });

  @override
  Future<R> transform({
    dynamic data,
    ResponseBody? responseBody,
  }) async {
    final cachedDataString = cacheManager.getString(cachingKey);

    if (cachedDataString == null) throw NonExistingCacheDataException(cachingKey);

    return await decodeDataBasedOnStrategy(
      TransformerStrategies.cache,
      requirements: requirements,
      data: await compute((input) => jsonDecode(input), cachedDataString),
    );
  }
}
