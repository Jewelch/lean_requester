part of "requester.dart";

/// CodingGOAT [_LeanTransformer] for [Dio].
///
/// [BackgroundTransformer] will do the deserialization of JSON in
/// a background isolate if possible.
class _LeanTransformer<R, M extends DAO> extends SyncTransformer {
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
  ) {
    super.jsonDecodeCallback = (jsonString) => compute(jsonDecode, jsonString);
  }

  Future<R> decodeMockingData() async {
    await Future.delayed(Duration(milliseconds: mockAwaitTime));

    dataAssertion(mockingData);

    try {
      if (dao is NoDataModel) {
        return dao.fromJson(true);
      }

      if (asList) {
        final daoList = DaoList<M>(key: listKey, item: dao);
        daoList.list = DaoList<M>(key: listKey, item: (dao)).fromJson(mockingData).list as List<M>;
        return daoList as R;
      }

      return dao.fromJson(mockingData);
    } catch (exception, stacktrace) {
      throw DataDecodingException<M>(exception, stacktrace);
    }
  }

  @override
  Future<R> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    final decodedData = await super.transformResponse(options, responseBody);

    dataAssertion(decodedData);

    try {
      if (dao is NoDataModel) {
        return dao.fromJson(responseBody.statusCode >= 200 && responseBody.statusCode < 300);
      }

      if (asList) {
        final daoList = DaoList<M>(key: listKey, item: dao);
        daoList.list = DaoList<M>(key: listKey, item: (dao)).fromJson(decodedData).list as List<M>;
        await cacheManager.setString(
            cachingKey,
            jsonEncode(
              DaoList<M>(item: dao, key: cachingKey, list: daoList.list).toJson(),
            ));

        return daoList as R;
      }

      final M result = dao.fromJson(decodedData);
      await cacheManager.setString(cachingKey, jsonEncode(result.toJson()));
      return result as R;
    } catch (exception, stacktrace) {
      throw DataDecodingException<M>(exception, stacktrace);
    }
  }

  void dataAssertion(data) {
    if (data is! List && data is! StringKeyedMap) throw UnsupportedDataTypeException();

    if (data is List && listKey != null) throw UnawaitedListKeyException(listKey);

    if (data is StringKeyedMap && listKey == null) throw MissingListKeyException();
  }
}
