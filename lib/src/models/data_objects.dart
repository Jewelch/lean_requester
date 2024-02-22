import 'package:equatable/equatable.dart';

// Data Transfer Object
abstract class DTO extends Equatable {
  const DTO();
}

// Data Access Object
base mixin DAO<T> {
  T fromJson(dynamic json);
  void toJson();
}
