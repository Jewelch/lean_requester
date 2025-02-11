import 'common_exception.dart';

class ServerException extends CommonException {
  ServerException([String? message]) : super(message ?? 'Server exception occurred.');

  factory ServerException.maxRetriesReached(
    String path, {
    required int maxRetriesPerRequest,
  }) =>
      ServerException('Request to $path failed after $maxRetriesPerRequest retries');

  factory ServerException.unexpected(
    String path, {
    required String methodName,
  }) =>
      ServerException(
        'Unexpected error occurred while processing the request to $path.\n'
        'Method: $methodName\n',
      );
}
