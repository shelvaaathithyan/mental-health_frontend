import 'package:flutter/material.dart';

import '../../core/theme.dart';

class MindfulHoursStatsScreen extends StatelessWidget {
  const MindfulHoursStatsScreen({super.key});

  static const String routeName = '/mindful-hours/stats';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back_ios_new,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Mindful Hours Stats',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: FreudColors.richBrown,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      _CircleIconButton(
                        icon: Icons.help_outline,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Center(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _MindfulDonutChart(),
                          _DonutCenterLabel(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleIconButton(
                        icon: Icons.settings,
                        onPressed: null,
                        backgroundColor: Colors.white,
                        iconColor: FreudColors.richBrown,
                      ),
                      SizedBox(width: 16),
                      _CircleIconButton(
                        icon: Icons.file_download_outlined,
                        onPressed: null,
                        backgroundColor: Colors.white,
                        iconColor: FreudColors.richBrown,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategoryTile(
                          label: 'Breathing',
                          value: '2.5h',
                          percentage: '20%',
                          color: FreudColors.mossGreen,
                        ),
                        SizedBox(height: 12),
                        _CategoryTile(
                          label: 'Mindfulness',
                          value: '1.7h',
                          percentage: '17%',
                          color: FreudColors.burntOrange,
                        ),
                        SizedBox(height: 12),
                        _CategoryTile(
                          label: 'Relax',
                          value: '8h',
                          percentage: '40%',
                          color: Color(0xFFE8C16A),
                        ),
                        SizedBox(height: 12),
                        _CategoryTile(
                          label: 'Sleep',
                          value: '8h',
                          percentage: '80%',
                          color: FreudColors.richBrown,
                        ),
                        Spacer(),
                        _SwipeHintCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Center(
              child: _FloatingActionButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? FreudColors.richBrown.withValues(alpha: 0.08);
    final color = iconColor ?? FreudColors.textLight;
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _MindfulDonutChart extends StatelessWidget {
  const _MindfulDonutChart();

  static const _segments = [
    _ChartSegment(color: FreudColors.mossGreen, value: 0.35),
    _ChartSegment(color: FreudColors.burntOrange, value: 0.18),
    _ChartSegment(color: Color(0xFFE8C16A), value: 0.16),
    _ChartSegment(color: FreudColors.richBrown, value: 0.31),
  ];

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _DonutChartPainter(_segments),
      size: Size.square(220),
    );
  }
}

class _ChartSegment {
  const _ChartSegment({required this.color, required this.value});

  final Color color;
  final double value;
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter(this.segments);

  final List<_ChartSegment> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36
      ..strokeCap = StrokeCap.butt;

    double startAngle = -90 * (3.1415926535 / 180);
    for (final segment in segments) {
      final sweepAngle = segment.value * 2 * 3.1415926535;
      paint.color = segment.color;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    final innerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = FreudColors.cream;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - 36, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutCenterLabel extends StatelessWidget {
  const _DonutCenterLabel();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '8.21h',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: FreudColors.richBrown,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: FreudColors.richBrown.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  final String label;
  final String value;
  final String percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: FreudColors.richBrown,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FreudColors.richBrown,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            percentage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: FreudColors.richBrown.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeHintCard extends StatelessWidget {
  const _SwipeHintCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        color: FreudColors.richBrown,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cached, color: FreudColors.richBrown),
          ),
          const SizedBox(width: 18),
          Text(
            'Swipe for AI suggestions',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FreudColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: FreudColors.mossGreen,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: FreudColors.mossGreen.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: FreudColors.textLight, size: 32),
    );
  }
}
