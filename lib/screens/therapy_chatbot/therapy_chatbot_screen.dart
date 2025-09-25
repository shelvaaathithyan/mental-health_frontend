import 'package:flutter/material.dart';

class TherapyChatbotScreen extends StatelessWidget {
  const TherapyChatbotScreen({super.key});

  static const String routeName = '/therapy-chatbot';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('AI Therapy Chatbot'),
      ),
    );
  }
}
