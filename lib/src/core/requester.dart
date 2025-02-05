import 'dart:async';
import 'dart:math' show Random, min;

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:cg_core_defs/connectivity/connectivity_monitor.dart';
import 'package:cg_core_defs/helpers/debugging_printer.dart';
import 'package:lean_requester/models_exp.dart';

import '../definitions/restful_methods.dart';
import '../exports.dart';
import '../extensions/shared_ext.dart';

part '../extensions/private_ext.dart';
part './dio_extensions.dart';
part './request_base.dart';
part './request_mixin.dart';
part 'transformer.dart';

typedef LeanRequester = _LeanRequester;

abstract class _LeanRequester extends LeanRequesterBase with LeanRequesterMixin {
  _LeanRequester(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor,
  );
}
