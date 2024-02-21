part of '../core/request_performer.dart';

extension _ListSecuredAdderExt<E> on List<E> {
  void ifNotNullAdd(E? element) {
    if (element == null) return;
    this[length++] = element;
  }

  void addBasedOnCondition(E element, {required bool condition}) {
    if (condition) this[length++] = element;
  }
}
