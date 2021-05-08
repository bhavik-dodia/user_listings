import 'package:http/http.dart' as http;

/// Manages api calls.
class APIService {
  static const _baseUrl = 'reqres.in';

  /// Generates a request for fetching users.
  static makeGetRequest() {
    return http
        .get(Uri.https(_baseUrl, 'api/users', {'page': '2'}))
        .onError((error, stackTrace) => throw error);
  }

  /// Generates a request for adding a new user.
  static makePostRequest(Map<String, dynamic> data) {
    return http
        .post(Uri.https(_baseUrl, 'api/users', data))
        .onError((error, stackTrace) => throw error);
  }

  /// Generates a request for deleting a user.
  static makeDeleteRequest(int id) {
    return http
        .delete(Uri.https(_baseUrl, 'api/users/$id'))
        .onError((error, stackTrace) => throw error);
  }
}
