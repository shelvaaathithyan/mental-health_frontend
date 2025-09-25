import 'dart:convert';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.isGuest,
    required this.createdAt,
  });

  final int id;
  final String email;
  final bool isGuest;
  final DateTime createdAt;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      email: json['email'] as String,
      isGuest: json['is_guest'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'is_guest': isGuest,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final DateTime expiresAt;
  final AuthUser user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
      expiresAt:
          DateTime.tryParse(json['expires_at'] as String? ?? '') ?? DateTime.now(),
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_at': expiresAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  String encode() => jsonEncode(toJson());

  static AuthResponse decode(String source) {
    return AuthResponse.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }
}

class AuthException implements Exception {
  AuthException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AuthException(statusCode: $statusCode, message: $message)';
}
