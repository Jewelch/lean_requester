import 'data_objects.dart';

final class DaoList<M extends DAO> extends DAO {
  final M? item;
  final String? key;
  List<M>? list;

  DaoList({this.list, this.item, this.key});

  @override
  DaoList<M> fromJson(json) {
    if (item == null) {
      throw ArgumentError('Item cannot be null when calling fromJson');
    }
    return DaoList<M>(
      list: ((key == null ? json : json[key]) as List).map<M>((e) => item!.fromJson(e)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (key != null) key!: list?.map((M e) => e.toJson()).toList(),
      };
}
