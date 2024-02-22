part of "requester.dart";

/// CodingGOAT [_LeanTransformer] for [Dio].
///
/// [BackgroundTransformer] will do the deserialization of JSON in
/// a background isolate if possible.
class _LeanTransformer<M extends DAO> extends SyncTransformer {
  final M dao;
  final dynamic mockingData;
  final bool mocking;
  final int mockAwaitTime;

  _LeanTransformer({
    required this.dao,
    this.mockingData,
    this.mocking = false,
    required this.mockAwaitTime,
  }) {
    super.jsonDecodeCallback = (jsonString) => compute(jsonDecode, jsonString);
  }

  Future<M> decodeMockingData() => Future.delayed(
        Duration(milliseconds: mockAwaitTime),
      ).then(
        (_) => dao.fromJson(mockingData),
      );

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    try {
      if (dao is NoDataModel) {
        return dao.fromJson(
          mocking ? true : (responseBody.statusCode >= 200 && responseBody.statusCode < 300),
        );
      }

      final decodedData = await super.transformResponse(options, responseBody);

      if (decodedData is! List && decodedData is! StringKeyedMap)
        throw DecodingException('[$_LeanTransformer => decode] Data should be either a List or a StringKeyedMap');

      return dao.fromJson(decodedData);
    } catch (_, __) {
      throw DecodingException('$_LeanTransformer Error decoding data for ${dao.runtimeType}');
    }
  }
}
