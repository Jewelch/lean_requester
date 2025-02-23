import 'package:equatable/equatable.dart';

import '../../../errors/index.dart';
import '../../../models/data_objects.dart';
import '../../../models/either.dart';

export 'package:dio/dio.dart';
export 'package:equatable/equatable.dart';

abstract class UseCase<E extends DTO, M extends DAO, R> {
  const UseCase({
    required this.modelToEntityMapper,
    required this.dataSourceFetcher,
  });

  final E Function(M) modelToEntityMapper;
  final Future<dynamic> Function(dynamic) dataSourceFetcher;

  UseCaseResult<R> call(dynamic params) async {
    try {
      final result = await dataSourceFetcher(params);
      if (R == List<E>) {
        return Right((result as List<M>).map(modelToEntityMapper).toList() as R);
      } else {
        return Right(modelToEntityMapper(result as M) as R);
      }
    } on CommonException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}

final class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

typedef UseCaseResult<T> = Future<Either<Failure, T>>;
