import 'requester_configuration.dart';
import 'requester_mixin.dart';

export '../transformer/definitons/authentication_strategy.dart';

class LeanRequester extends RequesterConfiguration with RequesterMixin {
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
