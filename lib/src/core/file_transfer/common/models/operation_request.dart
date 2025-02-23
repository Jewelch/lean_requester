import 'package:dio/dio.dart' show CancelToken;

import 'operation_progress.dart';

class FileOperationRequest {
  final void Function(OperationProgress)? onProgress;
  final CancelToken? cancelToken;

  const FileOperationRequest({
    this.onProgress,
    this.cancelToken,
  });
}
