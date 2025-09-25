import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Controllers/chat_controller.dart';

enum TtsState { playing, stopped, paused, continued }

class ApiService {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  final List<Map<String, String>> conversation = [];
  static FlutterTts flutterTts = FlutterTts();
  double volume = 0.7;
  double pitch = 1.0;
  double rate = 0.4;
  Map<String, String>? voice;

  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  dynamic initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    await flutterTts.speak(text.replaceAll(",", ""));
    Get.find<ChatController>().startListening();

    // if (_newVoiceText != null) {
    //   if (_newVoiceText!.isNotEmpty) {
    //     await flutterTts.speak(_newVoiceText!);
    //   } else {
    //     print("Text to speak is empty");
    //   }
    // }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null && kDebugMode) {
      debugPrint('Default TTS engine: $engine');
    }
  }

  Future<void> _getDefaultVoice() async {
    // Fetch the list of available voices
    List<dynamic> voices = await flutterTts.getVoices;
    if (kDebugMode) {
      debugPrint('Available voices: $voices');
    }

    // Find the en-AU-language voice
    var selectedVoice = voices.firstWhere(
      (voice) => voice['locale'] == 'en-AU',
      orElse: () => null,
    );

    if (selectedVoice != null) {
      voice = {
        'name': selectedVoice['name'],
        'locale': selectedVoice['locale'],
      };
      await flutterTts.setVoice(voice!);
      if (kDebugMode) {
        debugPrint('Selected voice: $voice');
      }
    } else {
      if (kDebugMode) {
        debugPrint('Desired voice not found.');
      }
    }

    if (voice != null && kDebugMode) {
      debugPrint('Active voice: $voice');
    }
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

    final uri =
        Uri.parse('$_baseUrl/$model:generateContent?key=$apiKey');

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
        debugPrint('Gemini response (${response.statusCode}): ${response.body}');
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
      await _speak(message);
      return message;
    } catch (error) {
      if (conversation.length - 1 == userIndex) {
        conversation.removeLast();
      }
      rethrow;
    }
  }
}
