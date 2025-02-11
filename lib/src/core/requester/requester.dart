import 'requester_configuration.dart';
import 'requester_mixin.dart';

export '../transformer/definitons/authentication_strategy.dart';

class LeanRequester extends RequesterConfiguration with RequesterMixin {
  LeanRequester(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor,
  );
}
