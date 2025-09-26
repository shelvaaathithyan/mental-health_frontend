import 'dart:convert';

import 'package:ai_therapy/Models/mindful_models.dart';
import 'package:ai_therapy/Services/backend_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MindfulService {
  MindfulService({BackendClient? client}) : _client = client ?? BackendClient();

  final BackendClient _client;

  Future<List<MindfulnessGoal>> listGoals({String? exerciseType}) async {
    final response = await _safeGet(
      '/mindful/catalog/goals',
      queryParameters: exerciseType != null ? {'exercise_type': exerciseType} : null,
    );
    final data = _decodeAsMap(response);
    final items = data['items'] as List<dynamic>? ?? const [];
    return items
        .map((item) => MindfulnessGoal.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<MindfulnessSoundscape>> listSoundscapes({bool? active}) async {
    final response = await _safeGet(
      '/mindful/catalog/soundscapes',
      queryParameters: active == null ? null : {'active': active},
    );
    final data = _decodeAsMap(response);
    final items = data['items'] as List<dynamic>? ?? const [];
    return items
        .map((item) => MindfulnessSoundscape.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<MindfulnessSession> createSession(MindfulSessionCreatePayload payload) async {
    final response = await _safePost(
      '/mindful/sessions',
      body: payload.toJson(),
    );
    final data = _decodeAsMap(response);
    return MindfulnessSession.fromJson(data);
  }

  Future<MindfulnessSessionList> listSessions({
    int limit = 20,
    int offset = 0,
    String? exerciseType,
    String? goalCode,
    String? range,
  }) async {
    final query = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (goalCode != null) 'goal_code': goalCode,
      if (range != null) 'range': range,
    };
    final response = await _safeGet(
      '/mindful/sessions',
      queryParameters: query,
    );
    final data = _decodeAsMap(response);
    return MindfulnessSessionList.fromJson(data);
  }

  Future<MindfulnessSession?> getActiveSession() async {
    final response = await _safeGet('/mindful/sessions/active');
    final data = _decodeAsMap(response);
    final sessionJson = data['session'] as Map<String, dynamic>?;
    if (sessionJson == null) return null;
    return MindfulnessSession.fromJson(sessionJson);
  }

  Future<MindfulnessSession> getSessionDetail(int sessionId) async {
    final response = await _safeGet('/mindful/sessions/$sessionId');
    final data = _decodeAsMap(response);
    return MindfulnessSession.fromJson(data);
  }

  Future<MindfulnessSession> updateSessionProgress(
    int sessionId,
    MindfulSessionProgressPayload payload,
  ) async {
    final response = await _safePatch(
      '/mindful/sessions/$sessionId/progress',
      body: payload.toJson(),
    );
    final data = _decodeAsMap(response);
    final session = data['session'] as Map<String, dynamic>?;
    if (session == null) {
      throw MindfulApiException(
        'Malformed response from progress endpoint',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
    return MindfulnessSession.fromJson(session);
  }

  Future<MindfulnessSession> completeSession(
    int sessionId,
    MindfulSessionCompletePayload payload,
  ) async {
    final response = await _safePatch(
      '/mindful/sessions/$sessionId/complete',
      body: payload.toJson(),
    );
    final data = _decodeAsMap(response);
    return MindfulnessSession.fromJson(data);
  }

  Future<List<MindfulnessSessionEvent>> listSessionEvents(
    int sessionId, {
    int limit = 200,
  }) async {
    final response = await _safeGet(
      '/mindful/sessions/$sessionId/events',
      queryParameters: {'limit': limit},
    );
    final data = _decodeAsMap(response);
    final items = data['items'] as List<dynamic>? ?? const [];
    return items
        .map((item) => MindfulnessSessionEvent.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<MindfulnessSessionEvent> addSessionEvent(
    int sessionId,
    MindfulSessionEventPayload payload,
  ) async {
    final response = await _safePost(
      '/mindful/sessions/$sessionId/events',
      body: payload.toJson(),
    );
    final data = _decodeAsMap(response);
    return MindfulnessSessionEvent.fromJson(data);
  }

  Future<MindfulnessStatsOverview> getStatsOverview({String? range}) async {
    final response = await _safeGet(
      '/mindful/stats/overview',
      queryParameters: range != null ? {'range': range} : null,
    );
    final data = _decodeAsMap(response);
    return MindfulnessStatsOverview.fromJson(data);
  }

  Future<List<MindfulnessDailyStat>> getDailyStats({
    int days = 30,
    String? exerciseType,
  }) async {
    final query = <String, dynamic>{
      'days': days,
      if (exerciseType != null) 'exercise_type': exerciseType,
    };
    final response = await _safeGet(
      '/mindful/stats/daily',
      queryParameters: query,
    );
    final data = _decodeAsMap(response);
    final items = data['items'] as List<dynamic>? ?? const [];
    return items
        .map((item) => MindfulnessDailyStat.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<http.Response> _safeGet(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('MindfulService → GET $path');
        if (queryParameters != null) {
          debugPrint('MindfulService → query: $queryParameters');
        }
      }
      return await _client.get(
        path,
        queryParameters: queryParameters,
      );
    } catch (error) {
      throw MindfulApiException('Failed to reach mindful API: $error');
    }
  }

  Future<http.Response> _safePost(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('MindfulService → POST $path');
        debugPrint('MindfulService → body: $body');
      }
      return await _client.post(
        path,
        body: body,
      );
    } catch (error) {
      throw MindfulApiException('Failed to reach mindful API: $error');
    }
  }

  Future<http.Response> _safePatch(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('MindfulService → PATCH $path');
        debugPrint('MindfulService → body: $body');
      }
      return await _client.patch(
        path,
        body: body,
      );
    } catch (error) {
      throw MindfulApiException('Failed to reach mindful API: $error');
    }
  }

  Map<String, dynamic> _decodeAsMap(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw MindfulApiException(
        'Mindful API error: ${response.statusCode}',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw MindfulApiException(
        'Unexpected response shape: ${response.body}',
        statusCode: response.statusCode,
        body: response.body,
      );
    } catch (error) {
      throw MindfulApiException(
        'Failed to parse mindful API response: $error',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
}
