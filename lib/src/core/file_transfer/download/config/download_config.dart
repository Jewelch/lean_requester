import 'dart:io' show File;

import 'package:dio/dio.dart';

import '../../../restful/enum/restful_methods.dart';
import '../../common/config/operation_configuration.dart';

class DownloadConfiguration extends OperationConfiguration {
  DownloadConfiguration({
    required super.urlPath,
    required this.savePath,
    super.method = RestfulMethods.get,
    super.baseUrl,
    super.headers,
    super.queryParameters,
    super.cancelToken,
    super.onProgress,
    this.deleteOnError = true,
    this.fileAccessMode = FileAccessMode.write,
    this.lengthHeader = Headers.contentLengthHeader,
    this.data,
    super.options,
    super.debugIt,
  }) {
    options = (options ?? Options())..method = method?.name ?? RestfulMethods.get.name;
  }

  final dynamic savePath;
  final bool deleteOnError;
  final FileAccessMode fileAccessMode;
  final String lengthHeader;
  final Object? data;
}

typedef DownloadResult = FileOperationResult<File>;
