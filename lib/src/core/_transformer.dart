part of "requester.dart";

/// CodingGOAT [LeanTransformer] for [Dio].
///
/// [BackgroundTransformer] will do the deserialization of JSON in
/// a background isolate if possible.
class LeanTransformer<M extends DAO> extends SyncTransformer {
  LeanTransformer({required this.dao, this.mockingData, this.mocking = false}) {
    super.jsonDecodeCallback = (jsonString) => compute(jsonDecode, jsonString);
  }

  M dao;
  dynamic mockingData;
  bool mocking = false;

  M decodeMockingData() => dao.fromJson(mockingData);

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    try {
      if (dao is NoDataModel) {
        return dao.fromJson({
          mocking ? true : (responseBody.statusCode >= 200 && responseBody.statusCode < 300),
        });
      }

      final decodedData = await super.transformResponse(options, responseBody);

      if (decodedData is! List && decodedData is! StringKeyedMap)
        throw DecodingException('[$LeanTransformer => decode] Data should be either a List or a StringKeyedMap');

      return dao.fromJson(decodedData);
    } catch (_, __) {
      throw DecodingException('$LeanTransformer Error decoding data for ${dao.runtimeType}');
    }
  }
}
