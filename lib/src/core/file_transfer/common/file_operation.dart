import 'dart:io' show File, ContentType;

import '../../../../datasource_exp.dart';
import '../../../extensions/private_ext.dart';
import '../../../models/data_objects.dart';
import '../../../models/either.dart';
import '../../config/requester_configuration.dart';
import 'config/operation_configuration.dart';

part '../download/download_mixin.dart';
part '../upload/upload_mixin.dart';

typedef UploadMixin = _UploadMixin;
typedef DownloadMixin = _DownloadMixin;

typedef FileOperationResult<T> = Either<Failure, T>;

abstract interface class FileOperation<T, C extends OperationConfiguration> {
  Future<void> prepareRequest(C configuration);
  Future<FileOperationResult<T>> executeRequest(C configuration);
  Failure handleError(dynamic error, String url);
}

mixin FileOperationMixin<T, C extends OperationConfiguration> on FileOperation<T, C> {
  Future<FileOperationResult<T>> executeFileOperation({
    required C configuration,
    required Future<void> Function(C) prepareRequest,
    required Future<FileOperationResult<T>> Function(C) executeRequest,
    required Failure Function(dynamic, String) handleError,
  }) async {
    try {
      await prepareRequest(configuration);
      return await executeRequest(configuration);
    } catch (e) {
      return Left(handleError(e, configuration.urlPath));
    }
  }
}
