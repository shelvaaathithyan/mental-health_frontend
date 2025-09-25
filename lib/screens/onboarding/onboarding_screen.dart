import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../Widgets/custom_button.dart';
import '../../core/theme.dart';
import '../auth/signin/signin_screen.dart';
import '../dashboard/mental_health_dashboard_screen.dart';

/// Onboarding screen introducing Emma with a warm, calming layout.
class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Hero Section ---
                Align(
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale: _pulseController,
                    child: Container(
                      height: 176,
                      width: 176,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x153D5AFE),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Image.asset(
                            'assets/robot.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms, curve: Curves.easeOut),

                const SizedBox(height: 48),

                // --- Headline & Tagline ---
                Text(
                  'Emma',
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ).animate(delay: 150.ms).fadeIn(duration: 500.ms),
                const SizedBox(height: 12),
                Text(
                  'Here for you.',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 18,
                    color: FreudColors.textDark.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ).animate(delay: 250.ms).fadeIn(duration: 500.ms),

                const SizedBox(height: 56),

                // --- CTA ---
                CustomButton(
                  text: 'Start with Emma',
                  onPressed: () {
                    Get.toNamed(SignInScreen.routeName);
                  },
                ).animate(delay: 350.ms).fadeIn(duration: 500.ms),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Get.offAllNamed(MentalHealthDashboardScreen.routeName);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        FreudColors.textDark.withValues(alpha: 0.7),
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Explore without sign-in'),
                ).animate(delay: 450.ms).fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
