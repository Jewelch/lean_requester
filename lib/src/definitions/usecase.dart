import 'package:equatable/equatable.dart';

import '../utils/networking_utilities.dart';

abstract interface class UseCase<T, P> {
  UsecaseResult<T> call(P params);
}

final class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
