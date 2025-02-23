import 'mixins/download_mixin.dart';
import 'mixins/restful_mixin.dart';
import 'requester_configuration.dart';

export '../transformer/definitons/authentication_strategy.dart';

class LeanRequester extends RequesterConfiguration with RestfulrMixin, DownloadMixin {
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
