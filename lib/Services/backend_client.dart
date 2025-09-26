import 'dart:convert';

import 'package:ai_therapy/Services/auth_local_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum RequestBodyType { json, formUrlEncoded }

class BackendClient {
  BackendClient({http.Client? client, AuthLocalStore? store})
      : _client = client ?? http.Client(),
        _store = store ?? GetStorageAuthLocalStore();

  final http.Client _client;
  final AuthLocalStore _store;

  static const _tokenKey = 'auth.accessToken';
  static const _tokenTypeKey = 'auth.tokenType';

  static String get baseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }

    if (kIsWeb) {
      // Browser requests can talk to a local FastAPI dev server on localhost.
      return 'http://localhost:8000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android emulators map the host machine's localhost to 10.0.2.2.
        return 'http://10.0.2.2:8000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'http://127.0.0.1:8000';
    }
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    Map<String, String>? headers,
    RequestBodyType bodyType = RequestBodyType.json,
  }) {
    return _send(
      'POST',
      path,
      body: body,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      headers: headers,
      bodyType: bodyType,
    );
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) {
    return _send(
      'GET',
      path,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      headers: headers,
    );
  }

  Future<http.Response> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    Map<String, String>? headers,
    RequestBodyType bodyType = RequestBodyType.json,
  }) {
    return _send(
      'PATCH',
      path,
      body: body,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      headers: headers,
      bodyType: bodyType,
    );
  }

  Future<http.Response> delete(
    String path, {
      Map<String, dynamic>? queryParameters,
      bool requiresAuth = true,
      Map<String, String>? headers,
    }) {
    return _send(
      'DELETE',
      path,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      headers: headers,
    );
  }

  Stream<String> postStream(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
    Map<String, String>? headers,
    RequestBodyType bodyType = RequestBodyType.json,
  }) async* {
    final uri = Uri.parse('$baseUrl$path');
    final effectiveHeaders = <String, String>{
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
      if (headers != null) ...headers,
    };

    Object? encodedBody;
    if (body != null) {
      switch (bodyType) {
        case RequestBodyType.json:
          effectiveHeaders['Content-Type'] = 'application/json';
          encodedBody = jsonEncode(body);
          break;
        case RequestBodyType.formUrlEncoded:
          effectiveHeaders['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8';
          encodedBody = body.entries
              .map((entry) =>
                  '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent('${entry.value}')}')
              .join('&');
          break;
      }
    }

    if (requiresAuth) {
      final token = _store.read<String>(_tokenKey);
      final tokenType = _store.read<String>(_tokenTypeKey) ?? 'Bearer';
      if (token == null || token.isEmpty) {
        throw StateError('Missing authentication token for authorized request.');
      }
      effectiveHeaders['Authorization'] = '${_formatTokenType(tokenType)} $token';
    }

    if (kDebugMode) {
      debugPrint('BackendClient → POST (stream) $uri');
    }

    final request = http.Request('POST', uri)
      ..headers.addAll(effectiveHeaders);

    if (encodedBody != null) {
      request.body = encodedBody as String;
    }

    final streamedResponse = await _client.send(request);

    if (streamedResponse.statusCode != 200) {
      throw Exception('Stream request failed: ${streamedResponse.statusCode}');
    }

    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      yield chunk;
    }
  }

  Future<http.Response> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    Map<String, String>? headers,
    RequestBodyType bodyType = RequestBodyType.json,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final effectiveHeaders = <String, String>{
      'Accept': 'application/json',
      if (headers != null) ...headers,
    };

    Object? encodedBody;
    if (method == 'POST' || method == 'PUT' || method == 'PATCH') {
      switch (bodyType) {
        case RequestBodyType.json:
          effectiveHeaders['Content-Type'] = 'application/json';
          encodedBody = jsonEncode(body ?? {});
          break;
        case RequestBodyType.formUrlEncoded:
          effectiveHeaders['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8';
          encodedBody = body == null
              ? ''
              : body.entries
                  .map((entry) =>
                      '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent('${entry.value}')}')
                  .join('&');
          break;
      }
    }

    if (requiresAuth) {
      final token = _store.read<String>(_tokenKey);
      final tokenType = _store.read<String>(_tokenTypeKey) ?? 'Bearer';
      if (token == null || token.isEmpty) {
        throw StateError('Missing authentication token for authorized request.');
      }
      effectiveHeaders['Authorization'] = '${_formatTokenType(tokenType)} $token';
    }

    if (kDebugMode) {
      debugPrint('BackendClient → $method $uri');
    }

    http.Response response;
    switch (method) {
      case 'POST':
        response = await _client
            .post(uri, headers: effectiveHeaders, body: encodedBody)
            .timeout(const Duration(seconds: 15));
        break;
      case 'GET':
        response = await _client
            .get(uri, headers: effectiveHeaders)
            .timeout(const Duration(seconds: 15));
        break;
      case 'PATCH':
        response = await _client
            .patch(uri, headers: effectiveHeaders, body: encodedBody)
            .timeout(const Duration(seconds: 15));
        break;
      case 'DELETE':
        response = await _client
            .delete(uri, headers: effectiveHeaders)
            .timeout(const Duration(seconds: 15));
        break;
      default:
        throw UnsupportedError('HTTP method not supported: $method');
    }

    if (kDebugMode) {
      debugPrint('BackendClient ← ${response.statusCode} ${response.reasonPhrase}');
    }

    return response;
  }

  String _formatTokenType(String tokenType) {
    if (tokenType.isEmpty) {
      return 'Bearer';
    }
    return tokenType[0].toUpperCase() + tokenType.substring(1).toLowerCase();
  }

  void dispose() {
    _client.close();
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final baseUri = Uri.parse('$baseUrl$path');
    if (queryParameters == null || queryParameters.isEmpty) {
      return baseUri;
    }

    final buffer = StringBuffer();
    if (baseUri.hasQuery) {
      buffer.write(baseUri.query);
    }

    void appendPair(String key, String value) {
      if (buffer.isNotEmpty) {
        buffer.write('&');
      }
      buffer
        ..write(Uri.encodeQueryComponent(key))
        ..write('=')
        ..write(Uri.encodeQueryComponent(value));
    }

    queryParameters.forEach((key, value) {
      if (value == null) return;
      if (value is Iterable) {
        for (final element in value) {
          if (element == null) continue;
          appendPair(key, element.toString());
        }
      } else {
        appendPair(key, value.toString());
      }
    });

    return baseUri.replace(query: buffer.toString());
  }
}
