import 'package:equatable/equatable.dart';

import 'repository_defs.dart';

export 'package:dio/dio.dart';
export 'package:equatable/equatable.dart';

typedef UsecaseResult<T> = RepositoryResult<T>;

abstract interface class UseCase<T, P> {
  UsecaseResult<T> call(P params);
}

final class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
