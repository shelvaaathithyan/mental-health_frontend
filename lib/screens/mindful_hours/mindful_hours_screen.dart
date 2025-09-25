import 'package:flutter/material.dart';

class MindfulHoursScreen extends StatelessWidget {
  const MindfulHoursScreen({super.key});

  static const String routeName = '/mindful-hours';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Mindful Hours with Voice Agent'),
      ),
    );
  }
}
