import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/stress_controller.dart';
import '../../core/theme.dart';
import 'stress_level_input_screen.dart';
import 'stress_select_stressors_screen.dart';

class StressLevelScreen extends StatelessWidget {
  static const String routeName = '/stress/overview';
  const StressLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StressController(), permanent: true);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top hero area with orange geometry and big number
            _HeroHeader(controller: controller),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Stress Stats', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Get.to(() => const SelectStressorsScreen()),
                          child: Text('See All', style: theme.textTheme.bodySmall?.copyWith(color: FreudColors.mossGreen)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _StatCard(controller: controller)),
                        const SizedBox(width: 14),
                        Expanded(child: _ImpactCard(controller: controller)),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const StressLevelInputScreen()),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Continue'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.controller});
  final StressController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  final double headerHeight = MediaQuery.of(context).size.height * 0.65;
    return Container(
      height: headerHeight,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: const BoxDecoration(
        color: FreudColors.burntOrange,
        gradient: LinearGradient(
          colors: [FreudColors.burntOrange, FreudColors.sunshine],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Back button at top-left
          Positioned(
            top: 4,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: FreudColors.textLight),
              onPressed: () => Get.offAllNamed('/dashboard'),
            ),
          ),
          // Decorative shapes
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -28,
            bottom: 24,
            child: Transform.rotate(
              angle: 0.6,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),

          // Content
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, left: 40),
              child: Text('Stress Level',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: FreudColors.textLight,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => Text(
                      controller.level.value.toString(),
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: FreudColors.textLight,
                        fontSize: 96,
                        fontWeight: FontWeight.w800,
                      ),
                    )),
                const SizedBox(height: 8),
                Obx(() => Text(
                      controller.overviewSubtitle,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: FreudColors.textLight,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              ],
            ),
          ),
          // Removed inner white lip layer to keep header clean per feedback
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.controller});
  final StressController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt_rounded, color: FreudColors.burntOrange),
                const SizedBox(width: 8),
                Text('Stressor', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Text(controller.selectedStressor.value,
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700))),
            const SizedBox(height: 12),
            const SizedBox(height: 6),
            const _GreenPills(),
          ],
        ),
      ),
    );
  }
}

// Trend card removed to stick to the provided mock (keeps layout tight with two stat cards and CTA)

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.controller});
  final StressController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: FreudColors.burntOrange),
                const SizedBox(width: 8),
                Text('Impact', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Text(controller.impactLabel,
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700))),
            const SizedBox(height: 12),
            const SizedBox(height: 6),
            const _PurpleGraph(),
          ],
        ),
      ),
    );
  }
}

class _GreenPills extends StatelessWidget {
  const _GreenPills();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(6, (i) {
          final w = [64.0, 52.0, 44.0, 68.0, 58.0, 40.0][i];
          return Container(
            width: w,
            height: 14,
            decoration: BoxDecoration(
              color: FreudColors.paleOlive.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      ),
    );
  }
}

class _PurpleGraph extends StatelessWidget {
  const _PurpleGraph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: CustomPaint(
        painter: _GraphPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFB39DDB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(size.width * 0.2, size.height * 0.2, size.width * 0.35,
        size.height * 0.9, size.width * 0.55, size.height * 0.4);
    path.cubicTo(size.width * 0.7, size.height * 0.1, size.width * 0.8,
        size.height * 0.9, size.width, size.height * 0.55);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
