import 'common_exception.dart';

class ResponseBodyException extends CommonException {
  factory ResponseBodyException.isNull() => ResponseBodyException._('Invalid or null response body.');

  factory ResponseBodyException.invalidStatusCode(int statusCode) =>
      ResponseBodyException._('Invalid response status code encountered ($statusCode)');

  ResponseBodyException._(super.message);
}
