part of "../requester/requester.dart";

/// CodingGOAT [LeanTransformer]
///
/// A transformer that can be used to transform data from a [Dio] request.
///
final class LeanTransformer<R, M extends DAO> extends StrategyBasedTransformer<R> {
  final M dao;
  final CacheManager cacheManager;
  final String cachingKey;
  final bool asList;
  final String? listKey;
  final dynamic mockingData;
  final int mockAwaitTime;

  LeanTransformer({
    required this.dao,
    required this.cacheManager,
    required this.cachingKey,
    required this.asList,
    required this.listKey,
    required this.mockingData,
    required this.mockAwaitTime,
  });

  late final cacheStrategy = CachedResponseTransformationStrategy<R, M>(
    RTStrategyRequirements(dao, asList, listKey),
    cacheManager: cacheManager,
    cachingKey: cachingKey,
  );

  late final mockStrategy = MockedResponseTransformationStrategy<R, M>(
    RTStrategyRequirements(dao, asList, listKey),
    mockAwaitTime: mockAwaitTime,
    mockingData: mockingData,
  );

  late final networkStrategy = NetworkResponseTransformationStrategy<R, M>(
    RTStrategyRequirements(dao, asList, listKey),
    cacheManager: cacheManager,
    cachingKey: cachingKey,
  );

  @override
  Future<R> transformCachedResponse() async => await cacheStrategy.transform();

  @override
  Future<R> transformMockedResponse() async => await mockStrategy.transform();

  @override
  Future<R> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async =>
      await networkStrategy.transform(
        data: await super.transformResponse(options, responseBody),
        responseBody: responseBody,
      );
}
