import 'dart:async';

import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:lean_requester/models_exp.dart';

import '../exports.dart';
import '../extensions/shared_ext.dart';
import './request_base.dart';
import './request_mixin.dart';

part './transformer.dart';

typedef LeanRequester = _LeanRequester;

class _LeanRequester extends LeanRequesterBase with LeanRequesterMixin {
  _LeanRequester(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor,
  );
}
