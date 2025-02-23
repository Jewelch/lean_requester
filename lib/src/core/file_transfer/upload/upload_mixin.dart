part of '../common/file_operation.dart';

mixin _UploadMixin<C extends OperationConfiguration> on RequesterConfiguration implements FileOperation<File, C> {
  @override
  Future<void> prepareRequest(C configuration) async {
    await dio.setupOptions(
      baseOptions,
      configuration.baseUrl,
      ContentType("multipart", "form-data"),
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
    if (configuration is! UploadConfiguration) {
      throw ArgumentError('Configuration must be a DownloadConfiguration');
    }

    final file = File(configuration.filePath);
    if (!await file.exists()) {
      return Left(Failure(message: 'File not found: ${configuration.filePath}'));
    }

    final formData = await _prepareFormData(configuration, file);

    final response = await dio.post(
      configuration.urlPath,
      data: formData,
      queryParameters: configuration.queryParameters,
      cancelToken: configuration.cancelToken,
      options: configuration.options,
      onSendProgress: (sent, total) => configuration.onUploadProgress?.call(
        OperationProgress(
          transferred: sent,
          total: total,
          progress: (sent / total * 100),
        ),
      ),
    );

    return Right(response.data);
  }

  @override
  Failure handleError(dynamic error, String url) {
    if (error is DioException) {
      return Failure(message: '$DioException -- Upload failed: ${error.message}');
    }
    return Failure(message: '${error.runtimeType} -- Unexpected error during upload to $url');
  }

  Future<FormData> _prepareFormData(UploadConfiguration configuration, File file) async {
    final formData = FormData();

    formData.files.add(
      MapEntry(
        configuration.fileKey,
        await MultipartFile.fromFile(
          configuration.filePath,
          filename: file.path.split('/').last,
        ),
      ),
    );

    configuration.extraData?.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    return formData;
  }
}
