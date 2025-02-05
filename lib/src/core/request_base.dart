part of "requester.dart";

abstract class LeanRequesterBase {
  LeanRequesterBase(
    this.dio,
    this.cacheManager,
    this.connectivityMonitor,
  );

  final Dio dio;
  final CacheManager cacheManager;
  final ConnectivityMonitor connectivityMonitor;

  BaseOptions get baseOptions => BaseOptions(
        connectTimeout: Duration(milliseconds: 20000),
        sendTimeout: Duration(milliseconds: 20000),
        receiveTimeout: Duration(milliseconds: 20000),
        contentType: ContentType.json.mimeType,
      );

  Map<String, dynamic> get headers => {};

  QueuedInterceptorsWrapper? get queuedInterceptorsWrapper => null;

  bool get mockingModeEnabled => false;
  int get mockAwaitDurationMs => 500;
  int get retryDelayMs => 2000;
  int get maxRetryDelayMs => 10000;

  bool get debuggingEnabled => false;
  bool get logRequestHeaders => false;
  bool get logResponseHeaders => false;
  bool get logRequestTimeout => false;
}
