import 'data_objects.dart';

final class NoDataModel extends DAO {
  final bool? success;

  NoDataModel({this.success});

  @override
  NoDataModel fromJson(dynamic json) => NoDataModel(success: json as bool);

  @override
  Map<String, dynamic> toJson() => {};
}
