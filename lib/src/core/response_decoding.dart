part of "request_performer.dart";

extension RequestPerformerDecoder on _PerformerMixin {
  dynamic _decode<M extends DAO>(
    M decodableModel, {
    Response<dynamic>? response,
    dynamic mockingData,
    bool mocking = false,
  }) async {
    assert(
      mockingData != null || response != null,
      '\n[$_PerformerMixin => decode] You should provide either some mocking data or a real response to be trated',
    );

    final data = mockingData ?? response?.data;

    if (mocking) await Future.delayed(Duration(milliseconds: mockAwaitDuraitonInMilliseconds));

    try {
      if (decodableModel is NoDataModel) {
        return decodableModel.fromJson({
          mocking ? true : (data.statusCode >= 200 && data.statusCode < 300),
        });
      }

      assert(
        data is List || data is StringKeyedMap,
        '\n[$_PerformerMixin => decode] Data should be either a List or a StringKeyedMap',
      );

      return decodableModel.fromJson(data);
    } catch (_, __) {
      throw DecodingException('Error decoding data for ${decodableModel.runtimeType}');
    }
  }
}
