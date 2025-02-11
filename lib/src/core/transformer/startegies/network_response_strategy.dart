import 'dart:convert' show jsonEncode;

import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:dio/dio.dart' show ResponseBody;
import 'package:flutter/foundation.dart' show compute;

import '../../../../models_exp.dart' show DAO, DaoList, NoDataModel;
import '../../../errors/index.dart' show ResponseBodyException;
import '../definitons/response_transformation_strategy.dart';

class NetworkResponseTransformationStrategy<R, M extends DAO> extends ResponseTransformationStrategy<R, M> {
  final CacheManager cacheManager;
  final String cachingKey;

  const NetworkResponseTransformationStrategy(
    super.requirements, {
    required this.cacheManager,
    required this.cachingKey,
  });

  @override
  Future<R> transform({
    ResponseBody? responseBody,
    dynamic data,
  }) async {
    validateResponse(responseBody);

    if (requirements.dao is NoDataModel) {
      return requirements.dao.fromJson(responseBody!.statusCode >= 200 && responseBody.statusCode < 300);
    }

    final R decodedData = await decodeDataBasedOnStrategy(
      TransformerStrategies.network,
      requirements: requirements,
      data: data,
    );
    await _storeToCache(decodedData);
    return decodedData;
  }

  void validateResponse(ResponseBody? responseBody) {
    if (responseBody == null) {
      throw ResponseBodyException.isNull();
    }
    if (responseBody.statusCode < 200 || responseBody.statusCode > 299) {
      throw ResponseBodyException.invalidStatusCode(responseBody.statusCode);
    }
  }

  Future<void> _storeToCache(R data) async {
    if (requirements.asList && data is DaoList<M>) {
      await cacheManager.setString(
        cachingKey,
        await compute(
          (input) => jsonEncode(input),
          DaoList<M>(item: requirements.dao, key: requirements.listKey, list: data.list).toJson(),
        ),
      );
    } else if (data is M) {
      await cacheManager.setString(
        cachingKey,
        await compute((input) => jsonEncode(input), data.toJson()),
      );
    }
  }
}
