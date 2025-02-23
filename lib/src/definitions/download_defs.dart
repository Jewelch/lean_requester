import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/index.dart';
import '../models/either.dart';
import 'restful_methods.dart';

class DownloadConfiguration {
  DownloadConfiguration({
    required this.urlPath,
    required this.savePath,
    this.method = RestfulMethods.get,
    this.baseUrl,
    this.headers,
    this.queryParameters,
    this.cancelToken,
    this.onReceiveProgress,
    this.deleteOnError = true,
    this.fileAccessMode = FileAccessMode.write,
    this.lengthHeader = Headers.contentLengthHeader,
    this.data,
    this.options,
    this.debugIt = false,
  }) {
    options = (options ?? Options())..method = method.name;
  }

  final String urlPath;
  final dynamic savePath;
  final RestfulMethods method;
  final String? baseUrl;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;
  final CancelToken? cancelToken;
  final void Function(DownloadProgress)? onReceiveProgress;
  final bool deleteOnError;
  final FileAccessMode fileAccessMode;
  final String lengthHeader;
  final Object? data;
  Options? options;
  final bool debugIt;
}

class DownloadRequest {
  final void Function(DownloadProgress)? onProgress;
  final CancelToken? cancelToken;

  DownloadRequest({
    this.onProgress,
    this.cancelToken,
  });
}

typedef DownloadResult = Either<Failure, File?>;

class DownloadProgress {
  final int received;
  final int total;
  final double progress;

  const DownloadProgress({
    required this.received,
    required this.total,
    required this.progress,
  });

  double get intPercentage => (received / total);
  String get formattedPercentage => '${((received / total) * 100).toStringAsFixed(0)}%';
  String get formattedSize => '${(total / 1024 / 1024).toStringAsFixed(1)} MB';
  String get formattedProgress => '${(received / 1024 / 1024).toStringAsFixed(1)} MB / $formattedSize';
}

enum DownloadState {
  notStarted,
  downloading,
  completed,
  failed,
}

enum DownloadError {
  downloadFailed,
  fileNotFound,
  unexpectedError,
}
