import 'dart:async';

import 'package:cg_core_defs/cache/cache_manager.dart';

import '../../exports.dart';
import '../transformer/definitons/response_transformation_strategy.dart';
import '../transformer/definitons/strategy_based_transformer.dart';
import '../transformer/startegies/cached_response_strategy.dart';
import '../transformer/startegies/mocked_response_strategy.dart';
import '../transformer/startegies/network_response_strategy.dart';
import 'requester_configuration.dart';
import 'requester_mixin.dart';

part '../transformer/transformer.dart';

class LeanRequester extends RequesterConfiguration with RequesterMixin {
  LeanRequester(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor,
  );
}
