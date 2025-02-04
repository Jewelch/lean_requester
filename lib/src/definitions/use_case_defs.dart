import 'package:equatable/equatable.dart';

import '../errors/index.dart';
import '../models/either.dart';

export 'package:dio/dio.dart';
export 'package:equatable/equatable.dart';

typedef UseCaseResult<T> = Future<Either<Failure, T>>;

abstract interface class UseCase<T, P> {
  UseCaseResult<T> call(P params);
}

final class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
