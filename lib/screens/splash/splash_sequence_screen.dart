import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../View/home_view.dart';
import '../../core/theme.dart';
import '../onboarding/onboarding_screen.dart';

class SplashSequenceScreen extends StatefulWidget {
  const SplashSequenceScreen({super.key, required this.isFirstTime});

  static const String routeName = '/splash';

  final bool isFirstTime;

  @override
  State<SplashSequenceScreen> createState() => _SplashSequenceScreenState();
}

class _SplashSequenceScreenState extends State<SplashSequenceScreen> {
  int _currentIndex = 0;

  final List<Duration> _stageDurations = const [
    Duration(milliseconds: 1600),
    Duration(milliseconds: 2200),
    Duration(milliseconds: 2400),
  ];

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  Future<void> _runSequence() async {
    for (var i = 0; i < _stageDurations.length; i++) {
      await Future.delayed(_stageDurations[i]);
      if (!mounted) return;
      setState(() => _currentIndex = i + 1);
    }

    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final next =
        widget.isFirstTime ? OnboardingScreen.routeName : HomeView.routeName;
    Get.offAllNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    final slides = <Widget>[
      const _BrandSplash(key: ValueKey('brand-splash')),
      const _LoadingSplash(key: ValueKey('loading-splash')),
      const _QuoteSplash(key: ValueKey('quote-splash')),
      const _FetchingSplash(key: ValueKey('fetching-splash')),
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: slides[_currentIndex],
    );
  }
}

class _BrandSplash extends StatelessWidget {
  const _BrandSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _LogoMark(
                size: 120,
                primaryColor: FreudColors.richBrown,
                secondaryColor: FreudColors.cocoa,
              ),
              const SizedBox(height: 32),
              Text(
                'Neptune.ai',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 28,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingSplash extends StatelessWidget {
  const _LoadingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.richBrown,
      body: Stack(
        children: [
          const _BackgroundCircle(
            diameter: 320,
            alignment: Alignment.topLeft,
            color: FreudColors.cocoa,
            opacity: 0.35,
            offset: Offset(-80, -60),
          ),
          const _BackgroundCircle(
            diameter: 260,
            alignment: Alignment.bottomRight,
            color: FreudColors.cocoa,
            opacity: 0.25,
            offset: Offset(70, 70),
          ),
          const _BackgroundCircle(
            diameter: 180,
            alignment: Alignment.centerRight,
            color: FreudColors.cocoa,
            opacity: 0.2,
            offset: Offset(90, -40),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '99%',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 56,
                color: FreudColors.textLight,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteSplash extends StatelessWidget {
  const _QuoteSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.burntOrange,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _LogoMark(
                size: 60,
                primaryColor: FreudColors.textLight,
                secondaryColor: FreudColors.textLight,
              ),
              const SizedBox(height: 48),
              Text(
                '“In the midst of winter, I found there was within me an invincible summer.”',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: FreudColors.textLight,
                  height: 1.4,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '— Albert Camus',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FreudColors.textLight.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FetchingSplash extends StatelessWidget {
  const _FetchingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.mossGreen,
      body: SafeArea(
        child: Stack(
          children: [
            const _BackgroundCircle(
              diameter: 360,
              alignment: Alignment.center,
              color: FreudColors.paleOlive,
              opacity: 0.25,
              offset: Offset(-120, -120),
            ),
            const _BackgroundCircle(
              diameter: 220,
              alignment: Alignment.centerRight,
              color: FreudColors.paleOlive,
              opacity: 0.30,
              offset: Offset(40, 110),
            ),
            const _BackgroundCircle(
              diameter: 120,
              alignment: Alignment.topRight,
              color: FreudColors.paleOlive,
              opacity: 0.35,
              offset: Offset(-20, -30),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Fetching Data...',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: FreudColors.textLight,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.vibration,
                        color: FreudColors.textLight,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Shake screen to interact!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: FreudColors.textLight.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    const gapFactor = 2.2;
    final dotSize = size / (4 + (3 / gapFactor));
    final gap = dotSize / gapFactor;

    Widget dot(Color color) => Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          dot(primaryColor),
          SizedBox(height: gap),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              dot(secondaryColor),
              SizedBox(width: gap),
              dot(primaryColor),
              SizedBox(width: gap),
              dot(secondaryColor),
            ],
          ),
          SizedBox(height: gap),
          dot(primaryColor),
        ],
      ),
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  const _BackgroundCircle({
    required this.diameter,
    required this.alignment,
    required this.color,
    required this.opacity,
    this.offset = Offset.zero,
  });

  final double diameter;
  final Alignment alignment;
  final Color color;
  final double opacity;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: opacity),
          ),
        ),
      ),
    );
  }
}
