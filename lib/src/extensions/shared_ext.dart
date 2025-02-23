import 'dart:io' show HttpHeaders;

import '../definitions/datasource_defs.dart';
import '../models/dao_list.dart';
import '../models/data_objects.dart';

typedef StringKeyedMap = Map<String, dynamic>;

extension HeadersInjections on StringKeyedMap {
  StringKeyedMap addExtraHeaders(StringKeyedMap? extraHeaders) => this..addAll(extraHeaders ?? {});

  void addIfAvailable(Map<String, dynamic>? element) {
    if (element != null && element.isNotEmpty && element.values.first != null) addAll(element);
  }

  StringKeyedMap setupContentType(String contentType) => this..addAll({HttpHeaders.contentTypeHeader: contentType});

  StringKeyedMap setupAcceptedResponseTypeTo(String acceptedFormat) =>
      this..addAll({HttpHeaders.acceptHeader: 'application/$acceptedFormat'});
}

extension DaoListExt on Future {
  DataSourceListResult<M> toListOf<M extends DAO>() async => ((await this) as DaoList<M>?)?.list?.cast<M>() ?? <M>[];
}
