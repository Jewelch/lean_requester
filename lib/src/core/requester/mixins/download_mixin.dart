import 'dart:io';

import 'package:dio/dio.dart';

import '../../../definitions/download_defs.dart';
import '../../../errors/index.dart';
import '../../../extensions/private_ext.dart';
import '../../../models/either.dart';
import '../requester_configuration.dart';

mixin DownloadMixin on RequesterConfiguration {
  Future<DownloadResult> download({
    required DownloadConfiguration configuration,
  }) async {
    try {
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
      return await _executeDownloadWith(configuration);
    } catch (e) {
      return Left(_handleDownloadError(e, configuration.urlPath));
    }
  }

  Future<DownloadResult> _executeDownloadWith(DownloadConfiguration configuration) async {
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
      onReceiveProgress: (received, total) => configuration.onReceiveProgress?.call((
        received: received,
        total: total,
        progress: (received / total * 100),
      )),
    );

    final file = File(configuration.savePath);
    return (await file.exists())
        ? Right(file)
        : Left(
            Failure(message: 'File not found after download: ${configuration.savePath}'),
          );
  }

  Failure _handleDownloadError(dynamic error, String url) => (error is DioException)
      ? Failure(message: '$DioException -- Download failed: ${error.message}')
      : Failure(message: '${error.runtimeType} -- Unexpected error during download from $url');
}
