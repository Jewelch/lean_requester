part of "../requester/requester.dart";

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
