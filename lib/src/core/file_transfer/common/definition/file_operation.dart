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
  final RequesterConfiguration _requesterConfig;
  final ContentType _contentType;
  final String _operationType;

  const _FileOperationExecutor(
    this._requesterConfig,
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
    await _requesterConfig.dio.setupOptions(
      _requesterConfig.baseOptions,
      configuration.baseUrl,
      _contentType,
      headers: {
        ...?(await _requesterConfig.authenticationStrategy?.getAuthorizationHeader()),
        ...?_requesterConfig.commonHeaders,
        ...?configuration.headers,
      },
    );

    _requesterConfig.dio.setupInterceptors(
      _requesterConfig.queuedInterceptorsWrapper,
      configuration.debugIt,
      _requesterConfig.debuggingEnabled,
      _requesterConfig.logRequestHeaders,
      _requesterConfig.logResponseHeaders,
      _requesterConfig.logRequestTimeout,
    );
  }

  Failure _handleError(dynamic error, String url) => (error is DioException)
      ? Failure(message: '$DioException -- $_operationType failed: ${error.message}')
      : Failure(message: '${error.runtimeType} -- Unexpected error during $_operationType from $url');
}
