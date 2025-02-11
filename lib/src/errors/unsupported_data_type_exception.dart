import 'common_exception.dart';

class UnsupportedDataTypeException extends CommonException {
  UnsupportedDataTypeException(Type runtimeType)
      : super('Unsupported data type encountered during decoding: $runtimeType');
}
