import 'dart:io';

import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:cg_core_defs/connectivity/connectivity_monitor.dart';
import 'package:dio/dio.dart';
import 'package:lean_requester/src/core/config/requester_configuration.dart';

import '../../tools/exports.dart';

class MockDio extends Mock implements Dio {}

class MockCacheManager extends Mock implements CacheManager {}

class MockConnectivityMonitor extends Mock implements ConnectivityMonitor {}

void main() {
  late MockDio mockDio;
  late MockCacheManager mockCacheManager;
  late MockConnectivityMonitor mockConnectivityMonitor;
  late RequesterConfiguration requesterConfiguration;

  setUp(() {
    mockDio = MockDio();
    mockCacheManager = MockCacheManager();
    mockConnectivityMonitor = MockConnectivityMonitor();
    requesterConfiguration = RequesterConfiguration(
      mockDio,
      mockCacheManager,
      mockConnectivityMonitor,
    );
  });

  test('baseOptions should have correct values', () {
    final baseOptions = requesterConfiguration.baseOptions;
    expect(baseOptions.connectTimeout, Duration(milliseconds: 20000));
    expect(baseOptions.sendTimeout, Duration(milliseconds: 20000));
    expect(baseOptions.receiveTimeout, Duration(milliseconds: 20000));
    expect(baseOptions.contentType, ContentType.json.mimeType);
  });

  test('headers should be null by default', () {
    expect(requesterConfiguration.commonHeaders, null);
  });

  test('queuedInterceptorsWrapper should be null by default', () {
    expect(requesterConfiguration.queuedInterceptorsWrapper, isNull);
  });

  test('mockingModeEnabled should be false by default', () {
    expect(requesterConfiguration.mockingModeEnabled, isFalse);
  });

  test('maxRetriesPerRequest should be 3 by default', () {
    expect(requesterConfiguration.maxRetriesPerRequest, 3);
  });

  test('mockAwaitDurationMs should be 500 by default', () {
    expect(requesterConfiguration.mockAwaitDurationMs, 500);
  });

  test('retryDelayMs should be 2000 by default', () {
    expect(requesterConfiguration.retryDelayMs, 2000);
  });

  test('maxRetryDelayMs should be 10000 by default', () {
    expect(requesterConfiguration.maxRetryDelayMs, 10000);
  });

  test('debuggingEnabled should be false by default', () {
    expect(requesterConfiguration.debuggingEnabled, isFalse);
  });

  test('logRequestHeaders should be false by default', () {
    expect(requesterConfiguration.logRequestHeaders, isFalse);
  });

  test('logResponseHeaders should be false by default', () {
    expect(requesterConfiguration.logResponseHeaders, isFalse);
  });

  test('logRequestTimeout should be false by default', () {
    expect(requesterConfiguration.logRequestTimeout, isFalse);
  });
}
