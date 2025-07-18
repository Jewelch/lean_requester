import 'package:cg_core_defs/strategies/cache/cache_manager.dart';
import 'package:lean_requester/lean_requester.dart';
import 'package:lean_requester/src/extensions/private_ext.dart';

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
}
