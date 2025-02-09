import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:cg_core_defs/connectivity/connectivity_monitor.dart';
import 'package:dio/dio.dart';
import 'package:lean_requester/src/core/requester/requester.dart';

import '../../tools/exports.dart';

class MockDio extends Mock implements Dio {}

class MockCacheManager extends Mock implements CacheManager {}

class MockConnectivityMonitor extends Mock implements ConnectivityMonitor {}

void main() {
  group('LeanRequester', () {
    late MockDio mockDio;
    late MockCacheManager mockCacheManager;
    late MockConnectivityMonitor mockConnectivityMonitor;
    late LeanRequester requester;

    setUp(() {
      mockDio = MockDio();
      mockCacheManager = MockCacheManager();
      mockConnectivityMonitor = MockConnectivityMonitor();
      requester = LeanRequester(mockDio, mockCacheManager, mockConnectivityMonitor);
    });

    test('should be instantiated correctly', () {
      expect(requester, isA<LeanRequester>());
    });
  });
}
