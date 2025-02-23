import '../../../../models_exp.dart';

/// A typedef for a Future that returns a single DAO model.
typedef DataSourceSingleResult<M extends DAO> = Future<M>;

/// A typedef for a Future that returns a list of DAO objects.
typedef DataSourceListResult<M extends DAO> = Future<List<M>>;

extension DaoListExt on Future {
  DataSourceListResult<M> toListOf<M extends DAO>() async => ((await this) as DaoList<M>?)?.list?.cast<M>() ?? <M>[];
}
