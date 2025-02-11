import 'package:dio/dio.dart' show ResponseBody;

import '../../../models/data_objects.dart';
import '../../../models/no_data_model.dart';
import '../definitons/response_transformation_strategy.dart';

class MockedResponseTransformationStrategy<R, M extends DAO> extends ResponseTransformationStrategy<R, M> {
  final dynamic mockingData;
  final int mockAwaitTime;

  const MockedResponseTransformationStrategy(
    super.requirements, {
    required this.mockingData,
    required this.mockAwaitTime,
  });

  @override
  Future<R> transform({
    dynamic data,
    ResponseBody? responseBody,
  }) async {
    await Future.delayed(Duration(milliseconds: mockAwaitTime));

    if (requirements.dao is NoDataModel) return requirements.dao.fromJson(true) as R;

    return await decodeDataBasedOnStrategy(
      TransformerStrategies.mock,
      requirements: requirements,
      data: mockingData,
    );
  }
}
