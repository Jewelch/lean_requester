import '../models/index.dart' show DAO;

/// A typedef for a Future that returns a single DAO model.
typedef DataSourceSingleResult<M extends DAO> = Future<M>;

/// A typedef for a Future that returns a list of DAO objects.
typedef DataSourceListResult<M extends DAO> = Future<List<M>>;

extension DaoListExt on Future {
  DataSourceListResult<M> toListOf<M extends DAO>() async => (await this).list?.cast<M>() ?? <M>[];
}
