import 'dart:io';

typedef StringKeyedMap = Map<String, dynamic>;

extension HeadersInjections on StringKeyedMap {
  StringKeyedMap addExtraHeaders(StringKeyedMap? extraHeaders) => this..addAll(extraHeaders ?? {});

  StringKeyedMap setupContentType(String contentType) => this..addAll({HttpHeaders.contentTypeHeader: contentType});

  StringKeyedMap setupAcceptedResponseTypeTo(String acceptedFormat) =>
      this..addAll({HttpHeaders.acceptHeader: 'application/$acceptedFormat'});
}
