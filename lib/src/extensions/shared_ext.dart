import 'dart:io';

typedef StringKeyedMap = Map<String, dynamic>;

extension HeadersInjections on StringKeyedMap {
  StringKeyedMap addExtraHeaders(StringKeyedMap? extraHeaders) => this..addAll(extraHeaders ?? {});

  void addIfAvailable(Map<String, dynamic>? element) {
    if (element != null && element.isNotEmpty && element.values.first != null) addAll(element);
  }

  StringKeyedMap setupContentType(String contentType) =>
      this..addAll({HttpHeaders.contentTypeHeader: contentType});

  StringKeyedMap setupAcceptedResponseTypeTo(String acceptedFormat) =>
      this..addAll({HttpHeaders.acceptHeader: 'application/$acceptedFormat'});
}
