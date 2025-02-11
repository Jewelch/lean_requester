import 'package:cg_core_defs/cg_core_defs.dart';
import 'package:equatable/equatable.dart';

abstract class CommonException implements Exception {
  final String message;

  CommonException(this.message) {
    Debugger.red('$runtimeType: $message');
  }

  Failure toFailure() => Failure(message: message);
}

base class Failure extends Equatable {
  const Failure({required this.message});

  final String message;
  @override
  List<Object> get props => [];
}
