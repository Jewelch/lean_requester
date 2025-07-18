import 'package:cg_core_defs/strategies/cache/cache_manager.dart';
import 'package:cg_core_defs/strategies/connectivity/connectivity_monitor.dart';
import 'package:dio/dio.dart';

import '../../tools/exports.dart';

class MockDio extends Mock implements Dio {}

class MockCacheManager extends Mock implements CacheManager {}

class MockConnectivityMonitor extends Mock implements ConnectivityMonitor {}
