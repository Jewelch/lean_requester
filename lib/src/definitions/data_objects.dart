import 'package:equatable/equatable.dart';

abstract class DTO extends Equatable {
  const DTO();
}

base mixin DAO<T> {
  T fromJson(dynamic json);
  void toJson() {}
}
