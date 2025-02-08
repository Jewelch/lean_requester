import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:lean_requester/lean_interceptor.dart';

import '../../tools/exports.dart';

class MockCacheManager extends Mock implements CacheManager {}

class MockDAO extends Mock implements DAO {}

void main() {
  late MockCacheManager mockCacheManager;
  late MockDAO mockDAO;
  late LeanTransformer transformer;

  setUp(() {
    mockCacheManager = MockCacheManager();
    mockDAO = MockDAO();
    transformer = LeanTransformer(
      mockCacheManager,
      'testKey',
      mockDAO,
      false,
      null,
      <String, dynamic>{},
      false,
      100,
    );
  });

  test('transformCachedData throws NonExistingCacheDataException if no cached data', () async {
    when(() => mockCacheManager.getString(any())).thenReturn(null);

    expect(
      () async => await transformer.transformCachedData(''),
      throwsA(isA<NonExistingCacheDataException>()),
    );
  });

  test('transformCachedData returns data when cached data exists', () async {
    when(() => mockCacheManager.getString(any())).thenReturn('{"key":"cachedData"}');
    when(() => mockDAO.fromJson(any())).thenReturn({'key': 'cachedData'});

    final result = await transformer.transformCachedData('');

    expect(result, {"key": "cachedData"});
  });

  test('transformMockResponse returns mocked data', () async {
    when(() => mockDAO.fromJson(any())).thenReturn({'key': 'mockedData'});

    transformer = LeanTransformer(
      mockCacheManager,
      'testKey',
      mockDAO,
      false,
      null,
      {'key': 'mockedData'},
      false,
      100,
    );

    final result = await transformer.transformMockResponse();

    expect(result, {'key': 'mockedData'});
  });

  test('transformMockResponse returns empty data when no mock data', () async {
    when(() => mockDAO.fromJson(any())).thenReturn({});

    transformer = LeanTransformer(
      mockCacheManager,
      'testKey',
      mockDAO,
      false,
      null,
      <String, dynamic>{},
      false,
      100,
    );

    final result = await transformer.transformMockResponse();

    expect(result, {});
  });

  test('transformResponse throws InvalidResponseStatusCode for invalid status code', () async {
    final responseBody = ResponseBody.fromString('{"error": "Not Found"}', 404, headers: {});

    expect(
      () async => await transformer.transformResponse(RequestOptions(path: ''), responseBody),
      throwsA(isA<InvalidResponseStatusCode>()),
    );
  });

  test('transformResponse returns deserialized data for valid response', () async {
    final responseBody = ResponseBody.fromString('{"key": "value"}', 200, headers: {});
    when(() => mockDAO.fromJson(any())).thenReturn({'key': 'deserializedData'});

    final result = await transformer.transformResponse(RequestOptions(path: ''), responseBody);

    expect(result, {'key': 'deserializedData'});
  });

  test('transformResponse throws FormatException for invalid JSON response', () async {
    final responseBody = ResponseBody.fromString('invalidJson', 200, headers: {
      'content-type': ['application/json']
    });

    expect(
      () async => await transformer.transformResponse(RequestOptions(path: ''), responseBody),
      throwsA(isA<FormatException>()),
    );
  });

  test('responseAssertion throws InvalidResponseStatusCode for invalid status code', () {
    final responseBody = ResponseBody.fromString('', 404, headers: {});
    expect(() => transformer.responseAssertion(responseBody), throwsA(isA<InvalidResponseStatusCode>()));
  });

  test('responseAssertion does not throw for valid status code (200)', () {
    final responseBody = ResponseBody.fromString('{"key": "value"}', 200, headers: {});
    expect(() => transformer.responseAssertion(responseBody), returnsNormally);
  });

  test('dataAssertion throws UnsupportedDataTypeException for unsupported data type', () {
    expect(() => transformer.dataAssertion(123), throwsA(isA<UnsupportedDataTypeException>()));
  });

  test('dataAssertion throws ListKeyException for unexpected list key', () {
    transformer = LeanTransformer(
      mockCacheManager,
      'testKey',
      mockDAO,
      true,
      'listKey',
      <String, dynamic>{},
      false,
      100,
    );

    expect(() => transformer.dataAssertion([]), throwsA(isA<ListKeyException>()));
  });

  test('dataAssertion throws ListKeyException for missing list key', () {
    transformer = LeanTransformer(
      mockCacheManager,
      'testKey',
      mockDAO,
      true,
      null,
      <String, dynamic>{},
      false,
      100,
    );

    expect(() => transformer.dataAssertion({'key': 'value'}), throwsA(isA<ListKeyException>()));
  });

  test('dataAssertion does not throw for valid map data with expected key', () {
    expect(() => transformer.dataAssertion({'listKey': 'value'}), returnsNormally);
  });

  test('dataAssertion throws ListKeyException for map data with unexpected key', () {
    transformer = LeanTransformer(
      mockCacheManager,
      'testKey',
      mockDAO,
      true,
      'listKey',
      <String, dynamic>{},
      false,
      100,
    );

    expect(
      () => transformer.dataAssertion(
        [
          {'unexpectedKey': 'value'}
        ],
      ),
      throwsA(isA<ListKeyException>()),
    );
  });

  test('dataAssertion does not throw for valid list data with expected key', () {
    transformer = LeanTransformer(
      mockCacheManager,
      'testKey',
      mockDAO,
      true,
      'listKey',
      <String, dynamic>{},
      false,
      100,
    );

    expect(
        () => transformer.dataAssertion(
              {
                "listKey": [
                  {'key': 'value'}
                ]
              },
            ),
        returnsNormally);
  });
}
