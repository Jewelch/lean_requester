import 'dart:io' show File, ContentType;

import '../../../../../datasource_exp.dart';
import '../../../../extensions/private_ext.dart';
import '../../../../models/data_objects.dart';
import '../../../../models/either.dart';
import '../config/operation_configuration.dart';

part '../../download/file_downloader.dart';
part '../../upload/filer_uploader.dart';

typedef FileOperationResult<T> = Either<Failure, T>;

abstract class _FileOperationExecutor<T, C extends OperationConfiguration> {
  final RequesterConfiguration requesterConfig;
  final ContentType _contentType;
  final String _operationType;

  const _FileOperationExecutor(
    this.requesterConfig,
    this._operationType,
    this._contentType,
  );

  Future<FileOperationResult<T>> _executeRequest(C configuration);

  Future<FileOperationResult<T>> _executeFileOperation({required C configuration}) async {
    try {
      await _prepareRequest(configuration);
      return await _executeRequest(configuration);
    } catch (e) {
      return Left(_handleError(e, configuration.urlPath));
    }
  }

  Future<void> _prepareRequest(C configuration) async {
    await requesterConfig.dio.setupOptions(
      requesterConfig.baseOptions,
      configuration.baseUrl,
      _contentType,
      headers: {
        ...?(await requesterConfig.authenticationStrategy?.getAuthorizationHeader()),
        ...?requesterConfig.commonHeaders,
        ...?configuration.headers,
      },
    );

    requesterConfig.dio.setupInterceptors(
      requesterConfig.queuedInterceptorsWrapper,
      configuration.debugIt,
      requesterConfig.debuggingEnabled,
      requesterConfig.logRequestHeaders,
      requesterConfig.logResponseHeaders,
      requesterConfig.logRequestTimeout,
    );
  }

  Failure _handleError(dynamic error, String url) => (error is DioException)
      ? Failure(message: '$DioException -- $_operationType failed: ${error.message}')
      : Failure(message: '${error.runtimeType} -- Unexpected error during $_operationType from $url');
}
