import 'data_objects.dart';

final class DaoList<M extends DAO> with DAO {
  final M? item;
  final String key;
  final List<M>? list;

  DaoList({this.list, this.item, required this.key});

  @override
  DaoList fromJson(json) => DaoList(
        list: (json[key] as List<dynamic>).map<M>((e) => item?.fromJson(e)).toList() as List<DAO>,
        key: '',
      );

  @override
  Map toJson() => {key: list};
}
