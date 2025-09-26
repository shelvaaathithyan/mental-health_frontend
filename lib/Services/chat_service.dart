import 'dart:async';

import 'package:ai_therapy/Models/chat_completion_model.dart';
import 'package:ai_therapy/Services/backend_client.dart';
import 'package:flutter/foundation.dart';

class ChatService {
  ChatService({BackendClient? client})
      : _client = client ?? BackendClient();

  final BackendClient _client;

  Stream<StreamingChatResponse> streamChat({
    required String message,
    String? userContext,
  }) async* {
    final request = ChatRequest(
      message: message,
      userContext: userContext,
    );

    try {
      if (kDebugMode) {
        debugPrint('ChatService → Streaming chat request');
        debugPrint('ChatService → Message: $message');
        if (userContext != null) {
          debugPrint('ChatService → User context: $userContext');
        }
      }

      bool firstDataSkipped = false;

      await for (final chunk in _client.postStream(
        '/chat',
        body: request.toJson(),
        requiresAuth: true,
        bodyType: RequestBodyType.json,
      )) {
        // Parse SSE format
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6); // Remove 'data: '
            if (data == '[DONE]') {
              if (kDebugMode) {
                debugPrint('ChatService ← Stream ended');
              }
              yield StreamingChatResponse(content: '', isDone: true);
              return;
            } else if (data.isNotEmpty) {
              if (!firstDataSkipped) {
                firstDataSkipped = true;
                continue; // Skip the first data chunk (thread_id)
              }
              if (kDebugMode) {
                debugPrint('ChatService ← Chunk: $data');
              }
              yield StreamingChatResponse(content: data, isDone: false);
            }
          }
        }
      }

    } catch (error) {
      if (kDebugMode) {
        debugPrint('ChatService error: $error');
      }
      rethrow;
    }
  }
}