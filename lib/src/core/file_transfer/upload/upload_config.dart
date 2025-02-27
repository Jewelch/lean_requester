import '../../../models/data_objects.dart';
import '../../restful/enum/restful_methods.dart';
import '../common/config/operation_configuration.dart';
import '../common/file_operation.dart';

class UploadConfiguration<M extends DAO> extends OperationConfiguration {
  UploadConfiguration({
    required super.urlPath,
    required this.filePath,
    required this.responseModel,
    this.fileKey = 'file',
    this.extraData,
    super.method = RestfulMethods.post,
    super.baseUrl,
    super.headers,
    super.queryParameters,
    super.cancelToken,
    super.onProgress,
    super.options,
    super.debugIt,
  });

  final String filePath;
  final String fileKey;
  final Map<String, dynamic>? extraData;
  final M responseModel;
}

typedef UploadResult = FileOperationResult<Object>;
