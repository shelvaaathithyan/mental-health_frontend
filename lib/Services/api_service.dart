import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const _elevenLabsVoiceId = 'QPBKI85w0cdXVqMSJ6WB';

  final List<Map<String, String>> conversation = [];

  Future<Uint8List> generateElevenLabsSpeech(String text) async {
    final apiKey = dotenv.env['ELEVENLABS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing ELEVENLABS_API_KEY in environment');
    }

    final uri = Uri.parse(
        'https://api.elevenlabs.io/v1/text-to-speech/$_elevenLabsVoiceId');
    final payload = {
      'text': text,
      'model_id': 'eleven_monolingual_v1',
      'voice_settings': {
        'stability': 0.5,
        'similarity_boost': 0.75,
        'style': 0.0,
        'use_speaker_boost': true,
      }
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'audio/mpeg',
        'xi-api-key': apiKey,
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      if (kDebugMode) {
        debugPrint('ElevenLabs TTS error (${response.statusCode}): '
            '${response.body}');
      }
      throw Exception('ElevenLabs TTS request failed');
    }

    return response.bodyBytes;
  }

  Future<String?> getChatCompletion(
      {required String prompt,
      required String model,
      required String basePrompt}) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY in environment');
    }

    conversation.add({'role': 'user', 'content': prompt});
    final userIndex = conversation.length - 1;

    final systemInstruction = {
      'parts': [
        {'text': basePrompt}
      ]
    };

    final contents = conversation
        .map((message) => {
              'role': message['role'] == 'assistant' ? 'model' : 'user',
              'parts': [
                {'text': message['content']}
              ],
            })
        .toList();

    final payload = {
      'system_instruction': systemInstruction,
      'contents': contents,
      'generation_config': {
        'temperature': 0.6,
        'topP': 0.9,
        'topK': 40,
        'maxOutputTokens': 1024,
        'responseModalities': ['TEXT'],
      }
    };

    final uri = Uri.parse('$_baseUrl/$model:generateContent?key=$apiKey');

    if (kDebugMode) {
      debugPrint(
          'Gemini request → model: $model, promptLength: ${prompt.length}');
    }

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        try {
          final errorBody = jsonDecode(response.body);
          final message = errorBody['error']?['message'] ?? response.body;
          if (kDebugMode) {
            debugPrint('Gemini error ($model): $message');
          }
          throw Exception('Gemini error: $message');
        } catch (_) {
          throw Exception(
              'Gemini request failed with status ${response.statusCode}');
        }
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (kDebugMode) {
        debugPrint(
            'Gemini response (${response.statusCode}): ${response.body}');
      }
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('Gemini returned no candidates');
      }

      final candidate = candidates.first;
      final content = candidate['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw Exception('Gemini candidate missing content');
      }

      final buffer = StringBuffer();
      for (final part in parts) {
        final text = part['text'];
        if (text is String) {
          buffer.write(text);
        }
      }

      final message = buffer.toString().trim();
      if (message.isEmpty) {
        throw Exception('Gemini returned empty response');
      }

  conversation.add({'role': 'assistant', 'content': message});
  return message;
    } catch (error) {
      if (conversation.length - 1 == userIndex) {
        conversation.removeLast();
      }
      rethrow;
    }
  }
}
