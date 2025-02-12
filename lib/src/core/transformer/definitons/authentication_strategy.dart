import '../../../extensions/shared_ext.dart';

abstract class AuthenticationStrategy {
  const AuthenticationStrategy();

  Future<StringKeyedMap> getAuthorizationHeader();
}


//= class OAuthAuthentication implements AuthenticationStrategy {
//   final String clientId;
//   final String clientSecret;

//   OAuthAuthentication(this.clientId, this.clientSecret);

//   @override
//   Future<StringKeyedMap> getAuthorizationHeader() async {
//+      Implement the logic to obtain the OAuth token
//+      This is a placeholder; you would typically make a network request here
        // return {'Authorization': 'Bearer <OAuth_Token>'};
//   }
// }


//! class JwtAuthentication implements AuthenticationStrategy {
//   final String token;

//   JwtAuthentication(this.token);

//   @override
//   Future<StringKeyedMap> getAuthorizationHeader() async {
//     return {'Authorization': 'Bearer $token'};
//   }
// }


//& class ApiKeyAuthentication implements AuthenticationStrategy {
//   final String apiKey;

//   ApiKeyAuthentication(this.apiKey);

//   @override
//   Future<StringKeyedMap> getAuthorizationHeader() async {
//     return {'Authorization': 'Bearer $apiKey'}; // or however your API expects the key
//   }
// }