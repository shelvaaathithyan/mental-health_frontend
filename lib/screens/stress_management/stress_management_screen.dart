import 'package:flutter/material.dart';

class StressManagementScreen extends StatelessWidget {
  const StressManagementScreen({super.key});

  static const String routeName = '/stress-management';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Stress Management (Crisis Support)'),
      ),
    );
  }
}
