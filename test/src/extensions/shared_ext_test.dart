// import 'package:lean_requester/lean_interceptor.dart';
// import 'package:lean_requester/src/extensions/shared_ext.dart';

// import '../../tools/exports.dart';

// void main() {
//   group('HeadersInjections', () {
//     test('addExtraHeaders adds extra headers', () {
//       final headers = <String, dynamic>{'key1': 'value1'};
//       final extraHeaders = <String, dynamic>{'key2': 'value2'};
//       final result = headers.addExtraHeaders(extraHeaders);
//       expect(result, {'key1': 'value1', 'key2': 'value2'});
//     });

//     test('addExtraHeaders handles null extra headers', () {
//       final headers = <String, dynamic>{'key1': 'value1'};
//       final result = headers.addExtraHeaders(null);
//       expect(result, {'key1': 'value1'});
//     });

//     test('addIfAvailable adds element if available', () {
//       final headers = <String, dynamic>{'key1': 'value1'};
//       final element = <String, dynamic>{'key2': 'value2'};
//       headers.addIfAvailable(element);
//       expect(headers, {'key1': 'value1', 'key2': 'value2'});
//     });

//     test('addIfAvailable does not add element if null', () {
//       final headers = <String, dynamic>{'key1': 'value1'};
//       headers.addIfAvailable(null);
//       expect(headers, {'key1': 'value1'});
//     });

//     test('addIfAvailable does not add element if empty', () {
//       final headers = <String, dynamic>{'key1': 'value1'};
//       headers.addIfAvailable({});
//       expect(headers, {'key1': 'value1'});
//     });

//     test('setupContentType sets content type', () {
//       final headers = <String, dynamic>{'key1': 'value1'};
//       final result = headers.setupContentType('application/json');
//       expect(result, {'key1': 'value1', HttpHeaders.contentTypeHeader: 'application/json'});
//     });

//     test('setupAcceptedResponseTypeTo sets accepted response type', () {
//       final headers = <String, dynamic>{'key1': 'value1'};
//       final result = headers.setupAcceptedResponseTypeTo('json');
//       expect(result, {'key1': 'value1', HttpHeaders.acceptHeader: 'application/json'});
//     });
//   });
// }
