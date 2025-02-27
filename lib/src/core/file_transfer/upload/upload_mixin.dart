part of '../common/file_operation.dart';

mixin _UploadMixin<C extends OperationConfiguration, M extends DAO> on RequesterConfiguration
    implements FileOperation<M, C> {
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
  Future<FileOperationResult<M>> executeRequest(C configuration) async {
    if (configuration is! UploadConfiguration<M>) {
      throw ArgumentError('Configuration must be an UploadConfiguration<$M>');
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
      onSendProgress: configuration.onProgress,
    );

    return Right(configuration.responseModel.fromJson(response.data) as M);
  }

  @override
  Failure handleError(dynamic error, String url) {
    if (error is DioException) {
      return Failure(message: '$DioException -- Upload failed: ${error.message}');
    }
    return Failure(message: '${error.runtimeType} -- Unexpected error during upload to $url');
  }

  Future<FormData> _prepareFormData(UploadConfiguration<M> configuration, File file) async {
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
