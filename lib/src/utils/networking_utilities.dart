import '../exports.dart';

//* Constants

//* Enums
enum RestfullMethods { get, post, put, delete, patch, download }

//* TypeDefs
typedef RepositoryResult<T> = Future<Either<Failure, T?>>;
typedef UsecaseResult<T> = RepositoryResult<T>;
typedef StringKeyedMap = Map<String, dynamic>;

//* Extensions
extension HeadersInjections on StringKeyedMap {
  StringKeyedMap addExtraHeaders(StringKeyedMap? extraHeaders) => this..addAll(extraHeaders ?? {});

  StringKeyedMap setupContentType(String contentType) => this..addAll({HttpHeaders.contentTypeHeader: contentType});

  StringKeyedMap setupAcceptedResponseTypeTo(String acceptedFormat) =>
      this..addAll({HttpHeaders.acceptHeader: 'application/$acceptedFormat'});
}

extension ListSecuredAdderExt<E> on List<E> {
  void ifNotNullAdd(E? element) {
    if (element == null) return;
    this[length++] = element;
  }

  void addBasedOnCondition(E element, {required bool condition}) {
    if (condition) this[length++] = element;
  }
}
