import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/stress_controller.dart';
import '../../core/theme.dart';

class StressLevelInputScreen extends StatelessWidget {
  static const String routeName = '/stress/level-input';
  const StressLevelInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<StressController>();

    return Scaffold(
      backgroundColor: FreudColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("What's your stress\nlevel today?",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 12),
              // Curved dotted path + knob that follows the arc
              SizedBox(
                height: 180,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) {
                    // Map local dx to t and then to level 1..5
                    final box = context.findRenderObject() as RenderBox?;
                    if (box == null) return;
                    final local = box.globalToLocal(d.globalPosition);
                    final t = (local.dx / box.size.width).clamp(0.0, 1.0);
                    final lvl = (t * 4).round() + 1;
                    controller.setLevel(lvl);
                  },
                  child: Stack(
                    children: [
                      const Positioned.fill(child: _ArcDottedPath()),
                      // Decorative pale dots on the second half
                      const _ArcDots(),
                      // Knob positioned along the quadratic bezier by level
                      Positioned.fill(
                        child: Obx(() {
                          final t = (controller.level.value - 1) / 4; // 0..1
                          return _ArcKnob(t: t);
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Right aligned number + label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 4),
                  Obx(() => Text(
                        controller.level.value.toString(),
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 96,
                          fontWeight: FontWeight.w800,
                          color: FreudColors.richBrown,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                    controller.levelLabel,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: FreudColors.textDark.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              const SizedBox(height: 12),
              // Quick level chips 1..5
              Obx(() {
                final current = controller.level.value;
                return Wrap(
                  spacing: 8,
                  children: List.generate(5, (i) {
                    final lvl = i + 1;
                    return ChoiceChip(
                      label: Text('$lvl'),
                      selected: current == lvl,
                      onSelected: (_) => controller.setLevel(lvl),
                    );
                  }),
                );
              }),
              const SizedBox(height: 16),
              // Spectrum bar for visual feedback
              Container(
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF66BB6A), // green
                      Color(0xFFFFEB3B), // yellow
                      Color(0xFFFF9800), // orange
                      Color(0xFFE53935), // red
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed('/stress/select-stressors'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ArcDottedPath extends StatelessWidget {
  const _ArcDottedPath();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CustomPaint(
        painter: _ArcDottedPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ArcDottedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = FreudColors.textDark.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // From bottom-left to top-right with a pleasing bow
    path.moveTo(0, size.height * 0.95);
    path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.35, size.width, size.height * 0.1);

    // Draw dotted by segments
    const dashWidth = 10.0;
    const dashSpace = 8.0;
    double distance = 0;
    final metrics = path.computeMetrics().first;
    while (distance < metrics.length) {
      final extract = metrics.extractPath(distance, distance + dashWidth);
      canvas.drawPath(extract, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArcDots extends StatelessWidget {
  const _ArcDots();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotsPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _DotsPainter extends CustomPainter {
  Offset _quad(Offset p0, Offset p1, Offset p2, double t) {
    final x = (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y = (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p0 = Offset(0, size.height * 0.95);
    final p1 = Offset(size.width * 0.35, size.height * 0.35);
    final p2 = Offset(size.width, size.height * 0.1);
    final paint = Paint()..color = FreudColors.textDark.withValues(alpha: 0.18);
    for (final t in const [0.55, 0.75, 0.95]) {
      final c = _quad(p0, p1, p2, t);
      canvas.drawCircle(c, 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArcKnob extends StatelessWidget {
  const _ArcKnob({required this.t});
  final double t; // 0..1 along the bezier

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Offset quad(Offset p0, Offset p1, Offset p2, double tt) {
        final x = (1 - tt) * (1 - tt) * p0.dx + 2 * (1 - tt) * tt * p1.dx + tt * tt * p2.dx;
        final y = (1 - tt) * (1 - tt) * p0.dy + 2 * (1 - tt) * tt * p1.dy + tt * tt * p2.dy;
        return Offset(x, y);
      }

      final p0 = Offset(0, constraints.maxHeight * 0.95);
      final p1 = Offset(constraints.maxWidth * 0.35, constraints.maxHeight * 0.35);
      final p2 = Offset(constraints.maxWidth, constraints.maxHeight * 0.1);
      final pos = quad(p0, p1, p2, t);
      return Stack(children: [
        Positioned(
          left: pos.dx - 26,
          top: pos.dy - 26,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: FreudColors.burntOrange,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.refresh_rounded, color: Colors.white),
          ),
        ),
      ]);
    });
  }
}
