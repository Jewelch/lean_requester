import 'package:dio/dio.dart' show ResponseBody;
import 'package:flutter/foundation.dart' show compute;

import '../../../../models_exp.dart' show DaoList, DAO;
import '../../../errors/exceptions.dart';
import '../../../extensions/shared_ext.dart';

abstract class ResponseTransformationStrategy<R, M extends DAO> with DataTransformationMixin<R, M> {
  final TransformerRequirements<M> requirements;

  const ResponseTransformationStrategy(this.requirements);

  Future<R> transform({
    dynamic data,
    ResponseBody? responseBody,
  });
}

mixin DataTransformationMixin<R, M extends DAO> {
  Future<R> decodeDataBasedOnStrategy(
    TransformerStrategies strategy, {
    required TransformerRequirements<M> requirements,
    required dynamic data,
  }) async {
    validateData(data);
    validateListKey(data, requirements.asList, requirements.listKey);

    try {
      return (requirements.asList)
          ? await compute(
              (input) => DaoList<M>(key: requirements.listKey, item: requirements.dao).fromJson(input) as R,
              data,
            )
          : await compute((input) => requirements.dao.fromJson(input) as R, data);
    } catch (exception, stacktrace) {
      throw DataDecodingException<M>.basedOn(strategy, exception, stacktrace);
    }
  }

  void validateData(
    dynamic data,
  ) {
    if (data is! List && data is! StringKeyedMap && data is! String) {
      throw UnsupportedDataTypeException(data.runtimeType);
    }
  }

  void validateListKey(
    dynamic data,
    bool asList,
    String? listKey,
  ) {
    if (data is List) {
      if (listKey != null) throw ListKeyException.unexpected(listKey);
    }

    if (data is StringKeyedMap) {
      if (asList && listKey == null) {
        throw ListKeyException.notProvided();
      }
      if (listKey != null && !data.containsKey(listKey)) {
        throw ListKeyException.notExisting(listKey);
      }
    }
  }
}

enum TransformerStrategies {
  cache,
  mock,
  network,
}

typedef TransformerRequirements<M extends DAO> = ({M dao, bool asList, String? listKey});
