import '../../../../../datasource_exp.dart' show RestfulMethods, Failure, CancelToken, Options, ProgressCallback;
import '../../../../models/either.dart';

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

typedef FileOperationResult<T> = Either<Failure, T>;
