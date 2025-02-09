import 'package:lean_requester/datasource_exp.dart';
import 'package:lean_requester/models_exp.dart';
import 'package:lean_requester/src/extensions/shared_ext.dart';

import '../../tools/exports.dart';

class MockDio extends Mock implements Dio {}

class MockDAO extends Mock implements DAO {}

class MockLeanRequester extends Mock implements LeanRequester {
  @override
  Dio get dio => MockDio();

  @override
  Future<R> request<R, M extends DAO>({
    required M dao,
    required String path,
    required RestfulMethods method,
    required String cachingKey,
    bool asList = false,
    String? listKey,
    bool debugIt = true,
    bool mockIt = false,
    dynamic mockingData,
    String? baseUrl,
    dynamic body,
    ContentType? contentType,
    StringKeyedMap? extraHeaders,
    StringKeyedMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    final response = super.noSuchMethod(
      Invocation.method(
        #request,
        [],
        {
          #asList: asList,
          #baseUrl: baseUrl,
          #body: body,
          #cachingKey: cachingKey,
          #cancelToken: cancelToken,
          #contentType: contentType,
          #dao: dao,
          #debugIt: debugIt,
          #extraHeaders: extraHeaders,
          #listKey: listKey,
          #method: method,
          #mockIt: mockIt,
          #mockingData: mockingData,
          #onReceiveProgress: onReceiveProgress,
          #onSendProgress: onSendProgress,
          #options: options,
          #path: path,
          #queryParameters: queryParameters,
        },
      ),
    ) as Future<Response<R>>;
    return response.then((res) => res.data as R);
  }
}

void main() {
  late MockLeanRequester mockLeanRequester;
  late MockDAO mockDAO;

  setUp(() {
    mockLeanRequester = MockLeanRequester();
    mockDAO = MockDAO();
  });

  test('request mixin performs request successfully', () async {
    when(
      () => mockLeanRequester.request(
        dao: mockDAO,
        method: RestfulMethods.get,
        path: '/test',
        cachingKey: 'testKey',
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async =>
          Response(data: 'Success', statusCode: 200, requestOptions: RequestOptions(path: '/test')),
    );

    final result = await mockLeanRequester.request<String, MockDAO>(
      dao: mockDAO,
      path: '/test',
      method: RestfulMethods.get,
      cachingKey: 'testKey',
    );

    expect(result, 'Success');
  });

  test('request mixin retries on failure', () async {
    when(
      () => mockLeanRequester.request<String, MockDAO>(
        dao: mockDAO,
        path: '/test',
        method: RestfulMethods.get,
        cachingKey: 'testKey',
      ),
    ).thenThrow(
      ServerException(),
    );

    expect(
      () async => await mockLeanRequester.request<String, MockDAO>(
        dao: mockDAO,
        path: '/test',
        method: RestfulMethods.get,
        cachingKey: 'testKey',
      ),
      throwsA(isA<ServerException>()),
    );

    verify(
      () => mockLeanRequester.dio.request(any(), options: any(named: 'options')),
    ).called(
      mockLeanRequester.maxRetriesPerRequest,
    );
  });

  test('request mixin returns cached data when offline', () async {
    when(() => mockLeanRequester.connectivityMonitor.isConnected).thenReturn(false);
    when(() => (mockLeanRequester.dio.transformer as LeanTransformer).transformCachedResponse())
        .thenAnswer((_) async => 'Cached Data');

    final result = await mockLeanRequester.request<String, MockDAO>(
      dao: mockDAO,
      path: '/test',
      method: RestfulMethods.get,
      cachingKey: 'testKey',
    );

    expect(result, 'Cached Data');
  });

  test('request mixin returns mock data when mocking is enabled', () async {
    when(() => (mockLeanRequester.dio.transformer as LeanTransformer).transformMockedResponse())
        .thenAnswer((_) async => 'Mock Data');

    final result = await mockLeanRequester.request<String, MockDAO>(
      dao: mockDAO,
      path: '/test',
      method: RestfulMethods.get,
      cachingKey: 'testKey',
      mockIt: true,
    );

    expect(result, 'Mock Data');
  });

  test('request mixin handles request with query parameters', () async {
    when(() => mockLeanRequester.dio.request(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(data: 'Success', statusCode: 200, requestOptions: RequestOptions()));

    final result = await mockLeanRequester.request<String, MockDAO>(
      dao: mockDAO,
      path: '/test',
      method: RestfulMethods.get,
      cachingKey: 'testKey',
      queryParameters: {'param1': 'value1'},
    );

    expect(result, 'Success');
  });

  test('request mixin handles request with body data', () async {
    when(() => mockLeanRequester.dio.request(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(data: 'Success', statusCode: 200, requestOptions: RequestOptions()));

    final result = await mockLeanRequester.request<String, MockDAO>(
      dao: mockDAO,
      path: '/test',
      method: RestfulMethods.post,
      cachingKey: 'testKey',
      body: {'key': 'value'},
    );

    expect(result, 'Success');
  });

  test('request mixin handles request with custom headers', () async {
    when(() => mockLeanRequester.dio.request(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(data: 'Success', statusCode: 200, requestOptions: RequestOptions()));

    final result = await mockLeanRequester.request<String, MockDAO>(
      dao: mockDAO,
      path: '/test',
      method: RestfulMethods.get,
      cachingKey: 'testKey',
      extraHeaders: {'Custom-Header': 'HeaderValue'},
    );

    expect(result, 'Success');
  });
}
