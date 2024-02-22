import 'data_objects.dart';

final class NoDataModel with DAO {
  final bool? success;

  NoDataModel({this.success});

  @override
  NoDataModel fromJson(dynamic json) => NoDataModel(success: json as bool);

  @override
  void toJson() {}
}
