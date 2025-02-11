import 'common_exception.dart';

final class ListKeyException extends CommonException {
  factory ListKeyException.notProvided() => ListKeyException._(
        "Response is a Map, but no `listKey` provided.",
      );

  factory ListKeyException.notExisting(String? listKey) => ListKeyException._(
        "List key '$listKey' not found in response.",
      );

  factory ListKeyException.unexpected(String? listKey) => ListKeyException._(
        "Expected a Map with key '$listKey', but received a List instead.",
      );

  ListKeyException._(super.message);
}
