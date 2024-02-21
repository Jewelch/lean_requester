import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

typedef RepositoryResult<T> = Future<Either<Failure, T?>>;
