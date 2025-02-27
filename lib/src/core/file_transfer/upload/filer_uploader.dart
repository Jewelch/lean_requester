part of '../common/definition/file_operation.dart';

class _FileUploader<C extends OperationConfiguration, M extends DAO> extends FileOperationExecutor<M, C> {
  _FileUploader(super.requesterConfig);

  @override
  String get _operationType => 'upload';

  @override
  ContentType get _contentType => ContentType("multipart", "form-data");

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

    configuration.extraData?.forEach((key, value) => formData.fields.add(MapEntry(key, value.toString())));

    return formData;
  }

  @override
  Future<FileOperationResult<M>> _executeRequest(C configuration) async {
    if (configuration is! UploadConfiguration<M>) {
      throw ArgumentError('Configuration must be an UploadConfiguration<$M>');
    }

    final file = File(configuration.filePath);
    if (!await file.exists()) {
      return Left(Failure(message: 'File not found: ${configuration.filePath}'));
    }

    final formData = await _prepareFormData(configuration, file);

    final response = await requesterConfig.dio.post(
      configuration.urlPath,
      data: formData,
      queryParameters: configuration.queryParameters,
      cancelToken: configuration.cancelToken,
      options: configuration.options,
      onSendProgress: configuration.onProgress,
    );

    return Right(configuration.responseModel.fromJson(response.data) as M);
  }

  Future<FileOperationResult<M>> upload(C configuration) async =>
      await _executeFileOperation(configuration: configuration);
}
