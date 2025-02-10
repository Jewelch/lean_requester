import '../models/index.dart';

/// A typedef for a Future that returns a single DAO model.
typedef DataSourceSingleResult<M extends DAO> = Future<M>;

/// A typedef for a Future that returns a list of DAO objects.
typedef DataSourceResultAsListOf<M extends DAO> = Future<List<M>>;

Future<List<T>> futureListOf<T extends DAO>({required Future<DaoList<T>> from}) async =>
    await from.then((value) => value.list ?? []);
