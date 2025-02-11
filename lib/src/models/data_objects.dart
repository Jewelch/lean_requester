import 'package:equatable/equatable.dart' show Equatable;

// Data Transfer Object
abstract class DTO extends Equatable {
  const DTO();
}

// Data Access Object
abstract class DAO<T> {
  T fromJson(dynamic json);
  Map<String, dynamic> toJson();
}
