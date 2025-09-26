import 'dart:convert';

import 'package:ai_therapy/Models/auth_models.dart';
import 'package:ai_therapy/Services/auth_local_store.dart';
import 'package:ai_therapy/Services/backend_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService({BackendClient? client, AuthLocalStore? store})
      : _client = client ?? BackendClient(store: store);

  final BackendClient _client;

  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      path: '/auth/register',
      payload: {'email': email, 'password': password},
      requiresAuth: false,
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      path: '/auth/login',
      payload: {'email': email, 'password': password},
      requiresAuth: false,
    );
  }

  Future<AuthResponse> guestLogin({
    String? displayName,
  }) async {
    return _authenticate(
      path: '/auth/guest',
      payload: displayName != null ? {'display_name': displayName} : {},
      requiresAuth: false,
    );
  }

  Future<AuthResponse> _authenticate({
    required String path,
    required Map<String, dynamic> payload,
    required bool requiresAuth,
  }) async {
    http.Response response;
    try {
      if (kDebugMode) {
        debugPrint('AuthService → POST $path');
        debugPrint('AuthService → Payload: $payload');
        debugPrint('AuthService → Requires Auth: $requiresAuth');
      }
      response = await _client.post(
        path,
        body: payload,
        requiresAuth: requiresAuth,
        bodyType: RequestBodyType.json,  // Always use JSON for auth endpoints
      );
    } on Exception catch (error) {
      if (kDebugMode) {
        debugPrint('AuthService error sending request: $error');
      }
      throw AuthException('Failed to reach authentication server.');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (kDebugMode) {
        debugPrint('AuthService ← ${response.statusCode} ${response.reasonPhrase}');
        debugPrint('AuthService ← Response: ${response.body}');
      }
      return AuthResponse.fromJson(data);
    }

    if (kDebugMode) {
      debugPrint('AuthService ← ${response.statusCode} ${response.reasonPhrase}');
      debugPrint('AuthService ← Error Response: ${response.body}');
    }

    String message = 'Authentication failed with status ${response.statusCode}';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final error = body['detail'] ?? body['message'];
      if (error is String && error.isNotEmpty) {
        message = error;
      }
    } catch (_) {
      // ignore parse errors
    }

    throw AuthException(message, statusCode: response.statusCode);
  }
}
