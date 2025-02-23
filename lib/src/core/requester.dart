import 'config/requester_configuration.dart';

export 'file_transfer/index.dart' show DownloadMixin, UploadMixin;
export 'restful/restful_mixin.dart' show RestfulMixin;
export 'restful/transformer/definition/authentication_strategy.dart';

class LeanRequester extends RequesterConfiguration {
  LeanRequester(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor, {
    super.authenticationStrategy,
    super.baseOptions,
    super.queuedInterceptorsWrapper,
    super.commonHeaders,
    super.mockingModeEnabled,
    super.maxRetriesPerRequest,
    super.mockAwaitDurationMs,
    super.retryDelayMs,
    super.debuggingEnabled,
    super.logRequestHeaders,
  });
}
