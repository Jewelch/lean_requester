part of '../common/definition/file_operation.dart';

class _FileDownloader<C extends OperationConfiguration> extends FileOperationExecutor<File, C> {
  _FileDownloader(super.requesterConfig);

  @override
  String get _operationType => 'download';

  @override
  ContentType get _contentType => ContentType.binary;

  @override
  Future<FileOperationResult<File>> _executeRequest(C configuration) async {
    if (configuration is! DownloadConfiguration) {
      throw ArgumentError('Configuration must be a DownloadConfiguration');
    }

    await requesterConfig.dio.download(
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
        : Left(Failure(message: 'File not found after download: ${configuration.savePath}'));
  }

  Future<FileOperationResult<File>> download(C configuration) async =>
      await _executeFileOperation(configuration: configuration);
}
