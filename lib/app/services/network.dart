import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'storage.dart';

class NoConnectionToServerError {}

class AuthenticationError {}

/// A service that offers networking post and get requests to the backend
/// servers. It depends on the authentication storage, so if the user's token
/// is stored there, the requests' headers are automatically enriched with the
/// access token.
class NetworkService {
  static const String apiUrl = "https://api.schul-cloud.org";

  final StorageService storage;

  NetworkService({@required this.storage}) : assert(storage != null);

  Future<void> _ensureConnectionExists() =>
      InternetAddress.lookup(apiUrl.substring(apiUrl.lastIndexOf('/') + 1));

  Future<http.Response> _makeCall(
    String path,
    Future<http.Response> Function(String url) call,
  ) async {
    try {
      await _ensureConnectionExists();
      var response = await call('$apiUrl/$path');

      if (response.statusCode == 401) {
        throw AuthenticationError();
      }

      // Succeed, if its a 2xx status code.
      if (response.statusCode ~/ 100 == 2) {
        return response;
      }

      throw UnimplementedError(
          'We should handle status code ${response.statusCode}. '
          'The body was: ${response.body}');
    } on SocketException catch (_) {
      throw NoConnectionToServerError();
    }
  }

  Map<String, String> _getHeaders() => {
        if (storage.token.getValue() != null)
          'Authorization': 'Bearer ${storage.token}',
      };

  /// Makes an http get request to the api.
  Future<http.Response> get(
    String path, {
    Map<String, String> parameters = const {},
  }) async {
    assert(path != null);
    assert(parameters != null);

    if (parameters.isNotEmpty) {
      path += '?' + parameters.keys.map((p) => '$p=${parameters[p]}').join('&');
    }
    return await _makeCall(
      path,
      (url) async => await http.get(url, headers: _getHeaders()),
    );
  }

  /// Makes an http post request to the api.
  Future<http.Response> post(String path, {dynamic body}) async {
    assert(path != null);

    return await _makeCall(
      path,
      (url) async => await http.post(url, headers: _getHeaders(), body: body),
    );
  }
}
