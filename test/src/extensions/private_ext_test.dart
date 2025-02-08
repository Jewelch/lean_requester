import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:lean_requester/lean_interceptor.dart';
import 'package:lean_requester/src/extensions/private_ext.dart';
import 'package:lean_requester/src/extensions/shared_ext.dart';

import '../../tools/exports.dart';

class MockDio extends Mock implements Dio {
  @override
  final interceptors = Interceptors();

  @override
  Transformer transformer = SyncTransformer();

  @override
  BaseOptions options = BaseOptions();
}

class MockCacheManager extends Mock implements CacheManager {}

class MockDAO extends Mock implements DAO {}

void main() {
  group('_ListSecuredAdderExt', () {
    test('ifNotNullAdd adds element if not null', () {
      final list = <int>[];
      list.ifNotNullAdd(1);
      expect(list, [1]);
    });

    test('ifNotNullAdd does not add element if null', () {
      final list = <int>[];
      list.ifNotNullAdd(null);
      expect(list, []);
    });

    test('addBasedOnCondition adds element if condition is true', () {
      final list = <int>[];
      list.addBasedOnCondition(1, condition: true);
      expect(list, [1]);
    });

    test('addBasedOnCondition does not add element if condition is false', () {
      final list = <int>[];
      list.addBasedOnCondition(1, condition: false);
      expect(list, []);
    });
  });

  group('_DioComponentsExt', () {
    late MockDio mockDio;
    late BaseOptions baseOptions;
    late StringKeyedMap defaultHeaders;
    late StringKeyedMap extraHeaders;
    late MockCacheManager mockCacheManager;
    late MockDAO mockDAO;

    setUp(() {
      mockDio = MockDio();
      baseOptions = BaseOptions();
      defaultHeaders = {};
      extraHeaders = {};
      mockCacheManager = MockCacheManager();
      mockDAO = MockDAO();
    });

    test('setupOptions sets Dio options correctly', () {
      mockDio.setupOptions(
        baseOptions,
        'https://example.com',
        ContentType.json,
        defaultHeaders,
        extraHeaders,
      );
      expect(mockDio.options.baseUrl, 'https://example.com');
      expect(mockDio.options.contentType, ContentType.json.mimeType);
      expect(mockDio.options.headers, {
        ...{"content-type": ContentType.json.mimeType},
        ...defaultHeaders,
        ...extraHeaders,
      });
    });

    test('setupInterceptors sets Dio interceptors correctly', () {
      final queuedInterceptorsWrapper = QueuedInterceptorsWrapper();
      mockDio.setupInterceptors(queuedInterceptorsWrapper, true, true, true, true, true);
      expect(mockDio.interceptors.contains(queuedInterceptorsWrapper), true);
    });

    test('setupTransformer sets Dio transformer correctly', () {
      mockDio.setupTransformer(
        mockCacheManager,
        'testKey',
        mockDAO,
        false,
        null,
        false,
        {},
        100,
      );
      expect(mockDio.transformer, isA<LeanTransformer>());
    });
  });
}
