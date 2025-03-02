part of '../common/definition/file_operation.dart';

class FileUploader<C extends OperationConfiguration, M extends DAO> extends _FileOperationExecutor<M, C> {
  FileUploader(RequesterConfiguration requesterConfig)
      : super(
          requesterConfig,
          'upload',
          ContentType("multipart", "form-data"),
        );

  Future<FormData> _prepareFormData(
    UploadConfiguration<M> configuration,
    File file,
  ) async {
    final formData = FormData()
      ..files.add(
        MapEntry(
          configuration.fileKey,
          await MultipartFile.fromFile(
            configuration.filePath,
            filename: file.path.split('/').last,
          ),
        ),
      );

    configuration.extraData?.forEach((key, value) => formData.fields.add(MapEntry(key, value.toString())));

    return formData;
  }

  @override
  Future<UploadResult<M>> _executeRequest(C configuration) async {
    if (configuration is! UploadConfiguration<M>) {
      throw ArgumentError('Configuration must be an $UploadConfiguration<$M>');
    }

    final file = File(configuration.filePath);
    if (!await file.exists()) {
      return Left(Failure(message: 'File not found: ${configuration.filePath}'));
    }

    final response = await _requesterConfig.dio.post(
      configuration.urlPath,
      data: await _prepareFormData(configuration, file),
      queryParameters: configuration.queryParameters,
      cancelToken: configuration.cancelToken,
      options: configuration.options,
      onSendProgress: configuration.onProgress,
    );

    return Right(configuration.responseModel.fromJson(response.data) as M);
  }

  Future<UploadResult<M>> upload(C configuration) async => (await _executeFileOperation(configuration: configuration));
}
