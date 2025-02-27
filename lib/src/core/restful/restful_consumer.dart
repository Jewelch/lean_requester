import 'dart:math' show Random, min;

import 'package:cg_core_defs/helpers/debugging_printer.dart';
import 'package:dio/dio.dart' show CancelToken, DioException, Options, ProgressCallback, DioMixin;

import '../../../datasource_exp.dart' show ContentType;
import '../../../models_exp.dart' show DAO;
import '../../errors/index.dart' show CommonException, ServerException;
import '../../extensions/private_ext.dart';
import '../../extensions/shared_ext.dart';
import '../config/requester_configuration.dart';
import 'enum/restful_methods.dart';
import 'transformer/definition/response_transformation_strategy.dart';
import 'transformer/transformer.dart';

class RestfulConsumer {
  final RequesterConfiguration requesterConfig;

  RestfulConsumer(this.requesterConfig);

  Future<R> request<R, M extends DAO>({
    TransformerRequirements<M>? requirements,
    M? requirement,
    required String path,
    required RestfulMethods method,
    String? cachingKey,
    bool debugIt = false,
    bool mockIt = false,
    dynamic mockingData,
    String? baseUrl,
    dynamic body,
    ContentType? contentType,
    StringKeyedMap? extraHeaders,
    StringKeyedMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    assert(
      requirement != null || requirements != null,
      'Either requirement (DAO) or requirements (DAO, asList, listKey) must be provided',
    );

    await requesterConfig.dio.setupOptions(
      requesterConfig.baseOptions,
      baseUrl,
      contentType,
      headers: {
        ...?(await requesterConfig.authenticationStrategy?.getAuthorizationHeader()),
        ...?requesterConfig.commonHeaders,
        ...?extraHeaders,
      },
    );

    requesterConfig.dio
      ..setupInterceptors(
        requesterConfig.queuedInterceptorsWrapper,
        debugIt,
        requesterConfig.debuggingEnabled,
        requesterConfig.logRequestHeaders,
        requesterConfig.logResponseHeaders,
        requesterConfig.logRequestTimeout,
      )
      ..setupTransformer<R, M>(
        requirements ?? (dao: requirement!, asList: false, listKey: null),
        requesterConfig.cacheManager,
        cachingKey ?? path,
        mockingData,
        requesterConfig.mockAwaitDurationMs,
      );

    final transformer = requesterConfig.dio.transformer as LeanTransformer<R, M>;

    if (!requesterConfig.connectivityMonitor.isConnected) {
      return await transformer.transformCachedResponse();
    }

    if (requesterConfig.mockingModeEnabled || mockIt) {
      return await transformer.transformMockedResponse();
    }

    return await _attemptNetworkRequest(
      path: path,
      body: body,
      queryParameters: queryParameters,
      method: method,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<R> _attemptNetworkRequest<R>({
    required String path,
    dynamic body,
    StringKeyedMap? queryParameters,
    required RestfulMethods method,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    for (int attempt = 1; attempt <= requesterConfig.maxRetriesPerRequest; attempt++) {
      if (attempt > 1) Debugger.orange('Attempt $attempt for request to ${requesterConfig.baseOptions.baseUrl + path}');

      try {
        final response = await requesterConfig.dio.request(
          path,
          data: body,
          queryParameters: queryParameters,
          options: DioMixin.checkOptions(method.name, options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
        return response.data;
      } on DioException catch (e) {
        Debugger.red("|| DioException<${e.type}, ${(e.error as CommonException).runtimeType}>");
        await _handleExceptions(attempt, path);
      } catch (e) {
        Debugger.red('Unexpected error during network request\n $e');
        await _handleExceptions(attempt, path);
      }
    }
    throw ServerException.unexpected(requesterConfig.baseOptions.baseUrl + path, methodName: method.name);
  }

  Future<void> _handleExceptions(int attempt, String path) async {
    if (attempt == requesterConfig.maxRetriesPerRequest)
      throw ServerException.maxRetriesReached(
        requesterConfig.baseOptions.baseUrl + path,
        maxRetriesPerRequest: requesterConfig.maxRetriesPerRequest,
      );

    await Future.delayed(_calculateDelayFor(attempt));
  }

  Duration _calculateDelayFor(int attempt) => Duration(
        milliseconds: min(
          (1 << (attempt - 1)) * requesterConfig.retryDelayMs + Random().nextInt(1000),
          requesterConfig.maxRetryDelayMs,
        ),
      );
}
