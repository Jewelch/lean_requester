import '../core/restful/transformer/definition/response_transformation_strategy.dart';
import 'common_exception.dart';

final class DataDecodingException<M> extends CommonException {
  factory DataDecodingException.basedOn(
    TransformerStrategies strategy,
    dynamic e,
    StackTrace s,
  ) =>
      switch (strategy) {
        TransformerStrategies.cache => DataDecodingException<M>._('Cache: $e', s),
        TransformerStrategies.mock => DataDecodingException<M>._('Mock: $e', s),
        TransformerStrategies.network => DataDecodingException<M>._('Network: $e', s),
      };

  DataDecodingException._(
    dynamic exception,
    StackTrace stacktrace,
  ) : super("$M $exception\n$stacktrace");
}
