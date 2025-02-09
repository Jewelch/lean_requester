import 'dart:io';

import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:cg_core_defs/connectivity/connectivity_monitor.dart';
import 'package:dio/dio.dart';
import 'package:lean_requester/src/core/requester/requester_configuration.dart';

import '../../tools/exports.dart';

class MockDio extends Mock implements Dio {}

class MockCacheManager extends Mock implements CacheManager {}

class MockConnectivityMonitor extends Mock implements ConnectivityMonitor {}

void main() {
  late MockDio mockDio;
  late MockCacheManager mockCacheManager;
  late MockConnectivityMonitor mockConnectivityMonitor;
  late RequesterConfiguration leanRequesterBase;

  setUp(() {
    mockDio = MockDio();
    mockCacheManager = MockCacheManager();
    mockConnectivityMonitor = MockConnectivityMonitor();
    leanRequesterBase = RequesterConfiguration(
      mockDio,
      mockCacheManager,
      mockConnectivityMonitor,
    );
  });

  test('baseOptions should have correct values', () {
    final baseOptions = leanRequesterBase.baseOptions;
    expect(baseOptions.connectTimeout, Duration(milliseconds: 20000));
    expect(baseOptions.sendTimeout, Duration(milliseconds: 20000));
    expect(baseOptions.receiveTimeout, Duration(milliseconds: 20000));
    expect(baseOptions.contentType, ContentType.json.mimeType);
  });

  test('headers should be empty by default', () {
    expect(leanRequesterBase.headers, {});
  });

  test('queuedInterceptorsWrapper should be null by default', () {
    expect(leanRequesterBase.queuedInterceptorsWrapper, isNull);
  });

  test('mockingModeEnabled should be false by default', () {
    expect(leanRequesterBase.mockingModeEnabled, isFalse);
  });

  test('maxRetriesPerRequest should be 3 by default', () {
    expect(leanRequesterBase.maxRetriesPerRequest, 3);
  });

  test('mockAwaitDurationMs should be 500 by default', () {
    expect(leanRequesterBase.mockAwaitDurationMs, 500);
  });

  test('retryDelayMs should be 2000 by default', () {
    expect(leanRequesterBase.retryDelayMs, 2000);
  });

  test('maxRetryDelayMs should be 10000 by default', () {
    expect(leanRequesterBase.maxRetryDelayMs, 10000);
  });

  test('debuggingEnabled should be false by default', () {
    expect(leanRequesterBase.debuggingEnabled, isFalse);
  });

  test('logRequestHeaders should be false by default', () {
    expect(leanRequesterBase.logRequestHeaders, isFalse);
  });

  test('logResponseHeaders should be false by default', () {
    expect(leanRequesterBase.logResponseHeaders, isFalse);
  });

  test('logRequestTimeout should be false by default', () {
    expect(leanRequesterBase.logRequestTimeout, isFalse);
  });
}
