import 'package:dio/dio.dart' show CancelToken;

class FileOperationRequest {
  final void Function(int transferred, int total)? onProgress;
  final CancelToken? cancelToken;

  const FileOperationRequest({
    this.onProgress,
    this.cancelToken,
  });
}

extension FileOperationRequestX on (int, int) {
  double get percentage => ($1 / $2);
  String get formattedPercentage => '${(percentage * 100).toStringAsFixed(0)}%';
  String get formattedSize => '${($2 / 1024 / 1024).toStringAsFixed(1)} MB';
  String get formattedProgress => '${($1 / 1024 / 1024).toStringAsFixed(1)} MB / $formattedSize';
}
