import 'package:cg_core_defs/cg_core_defs.dart' show CacheManager, ConnectivityMonitor;

import '../../../lean_requester.dart' show BaseOptions, ContentType, Dio, QueuedInterceptorsWrapper;
import '../../extensions/shared_ext.dart';
import '../transformer/definitons/authentication_strategy.dart';

class RequesterConfiguration {
  RequesterConfiguration(
    this.dio,
    this.cacheManager,
    this.connectivityMonitor, {
    this.authenticationStrategy,
    BaseOptions? baseOptions,
    this.queuedInterceptorsWrapper,
    this.commonHeaders,
    this.mockingModeEnabled = false,
    this.maxRetriesPerRequest = 3,
    this.mockAwaitDurationMs = 500,
    this.retryDelayMs = 2000,
    this.maxRetryDelayMs = 10000,
    this.debuggingEnabled = false,
    this.logRequestHeaders = false,
    this.logResponseHeaders = false,
    this.logRequestTimeout = false,
  }) : baseOptions = baseOptions ??
            BaseOptions(
              connectTimeout: Duration(milliseconds: 20000),
              sendTimeout: Duration(milliseconds: 20000),
              receiveTimeout: Duration(milliseconds: 20000),
              contentType: ContentType.json.mimeType,
            );

  final Dio dio;
  final CacheManager cacheManager;
  final ConnectivityMonitor connectivityMonitor;

  final AuthenticationStrategy? authenticationStrategy;

  final BaseOptions baseOptions;

  final StringKeyedMap? commonHeaders;

  final QueuedInterceptorsWrapper? queuedInterceptorsWrapper;

  final bool mockingModeEnabled;
  final int maxRetriesPerRequest;
  final int mockAwaitDurationMs;
  final int retryDelayMs;
  final int maxRetryDelayMs;

  final bool debuggingEnabled;
  final bool logRequestHeaders;
  final bool logResponseHeaders;
  final bool logRequestTimeout;
}
