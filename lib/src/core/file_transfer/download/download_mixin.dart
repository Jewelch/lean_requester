part of '../common/file_operation.dart';

mixin _DownloadMixin<C extends OperationConfiguration> on RequesterConfiguration implements FileOperation<File, C> {
  @override
  Future<void> prepareRequest(C configuration) async {
    await dio.setupOptions(
      baseOptions,
      configuration.baseUrl,
      ContentType.binary,
      headers: {
        ...?(await authenticationStrategy?.getAuthorizationHeader()),
        ...?commonHeaders,
        ...?configuration.headers,
      },
    );

    dio.setupInterceptors(
      queuedInterceptorsWrapper,
      configuration.debugIt,
      debuggingEnabled,
      logRequestHeaders,
      logResponseHeaders,
      logRequestTimeout,
    );
  }

  @override
  Future<FileOperationResult<File>> executeRequest(C configuration) async {
    if (configuration is! DownloadConfiguration) {
      throw ArgumentError('Configuration must be a DownloadConfiguration');
    }
    await dio.download(
      configuration.urlPath,
      configuration.savePath,
      cancelToken: configuration.cancelToken,
      deleteOnError: configuration.deleteOnError,
      lengthHeader: configuration.lengthHeader,
      queryParameters: configuration.queryParameters,
      fileAccessMode: configuration.fileAccessMode,
      data: configuration.data,
      options: configuration.options,
      onReceiveProgress: configuration.onProgress,
    );

    final file = File(configuration.savePath);
    return (await file.exists())
        ? Right(file)
        : Left(
            Failure(message: 'File not found after download: ${configuration.savePath}'),
          );
  }

  @override
  Failure handleError(dynamic error, String url) => (error is DioException)
      ? Failure(message: '$DioException -- Download failed: ${error.message}')
      : Failure(message: '${error.runtimeType} -- Unexpected error during download from $url');
}
