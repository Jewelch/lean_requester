part of "requester.dart";

abstract class FullSyncTransformer<R> extends SyncTransformer {
  FullSyncTransformer()
      : super(jsonDecodeCallback: (jsonString) {
          if (jsonString.length < 1000) {
            return jsonDecode(jsonString);
          } else {
            return compute(jsonDecode, jsonString);
          }
        });

  void responseAssertion(int statusCode);
  void dataAssertion(dynamic data);

  Future<R> transformCachedData(String cachedData);
  Future<R> transformMockResponse();
}

/// CodingGOAT [_LeanTransformer] for [Dio].
///
/// [BackgroundTransformer] will do the deserialization of JSON in
/// a background isolate if possible.
final class _LeanTransformer<R, M extends DAO> extends FullSyncTransformer {
  final CacheManager cacheManager;
  final String cachingKey;
  final M dao;
  final bool asList;
  final String? listKey;
  final dynamic mockingData;
  final bool mocking;
  final int mockAwaitTime;

  _LeanTransformer(
    this.cacheManager,
    this.cachingKey,
    this.dao,
    this.asList,
    this.listKey,
    this.mockingData,
    this.mocking,
    this.mockAwaitTime,
  );

  @override
  Future<R> transformCachedData(String cachedData) async {
    final cachedDataString = cacheManager.getString(cachingKey);
    if (cachedDataString == null) throw NonExistingCacheDataException(cachingKey);
    try {
      return await _deserializeData(jsonDecode(cachedDataString));
    } catch (exception, stacktrace) {
      throw DataDecodingException<M>.cache(exception, stacktrace);
    }
  }

  @override
  Future<R> transformMockResponse() async {
    await Future.delayed(Duration(milliseconds: mockAwaitTime));
    dataAssertion(mockingData);

    try {
      if (dao is NoDataModel) {
        return dao.fromJson(true);
      }
      return await _deserializeData(mockingData);
    } catch (exception, stacktrace) {
      throw DataDecodingException<M>.mock(exception, stacktrace);
    }
  }

  @override
  Future<R> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    responseAssertion(responseBody.statusCode);
    final decodedData = await super.transformResponse(options, responseBody);
    dataAssertion(decodedData);

    try {
      if (dao is NoDataModel) {
        return dao.fromJson(responseBody.statusCode >= 200 && responseBody.statusCode < 300);
      }

      final R data = await _deserializeData(decodedData);
      await _cacheData(data);
      return data;
    } catch (exception, stacktrace) {
      throw DataDecodingException<M>.network(exception, stacktrace);
    }
  }

  Future<R> _deserializeData(dynamic data) async {
    if (asList) {
      if (data is StringKeyedMap && listKey != null && !data.containsKey(listKey)) {
        throw ListKeyException.notExisting(listKey);
      }
      return await compute(
        (input) {
          final daoList = DaoList<M>(key: listKey, item: dao);
          return daoList.fromJson(input) as R;
        },
        data,
      );
    } else {
      return await compute(
        (input) => dao.fromJson(input) as R,
        data,
      );
    }
  }

  Future<void> _cacheData(R data) async {
    if (asList && data is DaoList<M>) {
      await cacheManager.setString(
        cachingKey,
        jsonEncode(DaoList<M>(item: dao, key: listKey, list: data.list).toJson()),
      );
    } else if (data is M) {
      await cacheManager.setString(cachingKey, jsonEncode(data.toJson()));
    }
  }

  @override
  void responseAssertion(int statusCode) {
    if (statusCode < 200 || statusCode > 299) throw InvalidResponseStatusCode(statusCode);
  }

  @override
  void dataAssertion(dynamic data) {
    if (data is! List && data is! StringKeyedMap) {
      throw UnsupportedDataTypeException();
    }

    if (data is List && listKey != null) {
      throw ListKeyException.unexpected(listKey);
    }

    if (data is StringKeyedMap && asList && listKey == null) {
      throw ListKeyException.notProvided();
    }
  }
}
