import 'package:equatable/equatable.dart';

import '../errors/index.dart';
import '../models/either.dart';

export 'package:dio/dio.dart';
export 'package:equatable/equatable.dart';

typedef UsecaseResult<T> = Future<Either<Failure, T>>;

abstract interface class UseCase<T, P> {
  UsecaseResult<T> call(P params);
}

final class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
