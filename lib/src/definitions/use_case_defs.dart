import 'package:equatable/equatable.dart';

import '../errors/index.dart';
import '../models/data_objects.dart';
import '../models/either.dart';

export 'package:dio/dio.dart';
export 'package:equatable/equatable.dart';

abstract class UseCase<Entity extends DTO, Model extends DAO, Params> {
  // Define the mapping function
  final Entity Function(Model) modelToEntityMapper;

  const UseCase({
    required this.modelToEntityMapper,
  });

  UseCaseResult call(Params params);
}

abstract class SingleResultUseCase<Entity extends DTO, Model extends DAO, Params>
    extends UseCase<Entity, Model, Params> {
  const SingleResultUseCase({
    required super.modelToEntityMapper,
    required this.dataSourceEntry,
  });

  final Future<Model> Function(Params) dataSourceEntry;

  @override
  UseCaseResult<Entity> call(Params params) async {
    try {
      final model = await dataSourceEntry.call(params);
      return Right(modelToEntityMapper(model));
    } on CommonException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}

abstract class ListResultUseCase<Entity extends DTO, Model extends DAO, Params> extends UseCase<Entity, Model, Params> {
  const ListResultUseCase({
    required super.modelToEntityMapper,
    required this.dataSourceEntry,
  });

  final Future<List<Model>> Function(Params) dataSourceEntry;

  @override
  UseCaseResult<List<Entity>> call(Params params) async {
    try {
      final model = await dataSourceEntry.call(params);
      return Right(model.map(modelToEntityMapper).toList());
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
