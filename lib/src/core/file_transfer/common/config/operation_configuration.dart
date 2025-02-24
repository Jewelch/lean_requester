import 'package:dio/dio.dart' show CancelToken, Options, ProgressCallback;

import '../../../restful/enum/restful_methods.dart';

abstract class OperationConfiguration {
  OperationConfiguration({
    required this.urlPath,
    this.method,
    this.baseUrl,
    this.headers,
    this.queryParameters,
    this.cancelToken,
    this.options,
    this.onProgress,
    this.debugIt = false,
  });

  final String urlPath;
  final RestfulMethods? method;
  final String? baseUrl;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;
  final CancelToken? cancelToken;
  Options? options;
  final ProgressCallback? onProgress;
  final bool debugIt;
}
