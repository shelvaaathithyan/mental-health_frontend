import 'package:flutter/material.dart';

class MentalHealthDashboardScreen extends StatelessWidget {
  const MentalHealthDashboardScreen({super.key});

  static const String routeName = '/dashboard/mental-health';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home & Mental Health Score Dashboard'),
      ),
    );
  }
}
