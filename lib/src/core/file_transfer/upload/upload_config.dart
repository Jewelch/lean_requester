import 'package:dio/dio.dart';

import '../../restful/enum/restful_methods.dart';
import '../common/config/operation_configuration.dart';
import '../common/file_operation.dart';
import '../common/models/operation_progress.dart';

class UploadConfiguration extends OperationConfiguration {
  UploadConfiguration({
    required super.urlPath,
    required this.filePath,
    super.method = RestfulMethods.post,
    super.baseUrl,
    super.headers,
    super.queryParameters,
    super.cancelToken,
    this.onUploadProgress,
    this.fileKey = 'file',
    this.extraData,
    super.options,
    super.debugIt,
  }) {
    options = (options ?? Options())..method = method?.name ?? RestfulMethods.post.name;
  }

  final String filePath;
  final void Function(OperationProgress)? onUploadProgress;
  final String fileKey;
  final Map<String, dynamic>? extraData;
}

typedef UploadResult = FileOperationResult<Object>;
