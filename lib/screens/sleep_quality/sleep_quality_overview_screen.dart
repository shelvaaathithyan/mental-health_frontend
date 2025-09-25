import 'package:flutter/material.dart';
import 'package:ai_therapy/core/theme.dart';
import 'sleep_quality_history_screen.dart';
import 'sleep_quality_tips_screen.dart';

class SleepQualityOverviewScreen extends StatelessWidget {
  static const String routeName = '/sleep-quality';

  const SleepQualityOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: FreudColors.cream,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: FreudColors.richBrown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Sleep Quality',
          style: theme.textTheme.titleLarge?.copyWith(
            color: FreudColors.richBrown,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SleepSummaryCard(),
            const SizedBox(height: 24),
            Text(
              'Tonight\'s Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                color: FreudColors.richBrown,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _SleepMetricTile(
                    label: 'Total Sleep',
                    value: '5h 12m',
                    deltaLabel: '+32m vs Avg',
                    icon: Icons.nightlight_round,
                    background: Color(0xFFE8E3FF),
                    iconColor: Color(0xFF6C5BD4),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _SleepMetricTile(
                    label: 'Deep Sleep',
                    value: '1h 05m',
                    deltaLabel: '-12m vs Avg',
                    icon: Icons.bedtime_rounded,
                    background: Color(0xFFD5F3EA),
                    iconColor: Color(0xFF3E8D75),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Expanded(
                  child: _SleepMetricTile(
                    label: 'REM Cycle',
                    value: '48%',
                    deltaLabel: '+5% vs Avg',
                    icon: Icons.bubble_chart_rounded,
                    background: Color(0xFFFDEBE0),
                    iconColor: FreudColors.burntOrange,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _SleepMetricTile(
                    label: 'Sleep Latency',
                    value: '18m',
                    deltaLabel: 'Fell asleep faster',
                    icon: Icons.timelapse_rounded,
                    background: Color(0xFFFFF3DF),
                    iconColor: Color(0xFFE4A03E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Sleep Stages',
              style: theme.textTheme.titleMedium?.copyWith(
                color: FreudColors.richBrown,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const _SleepStagesChart(),
            const SizedBox(height: 28),
            Text(
              'Insights',
              style: theme.textTheme.titleMedium?.copyWith(
                color: FreudColors.richBrown,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const _InsightCard(
              title: 'Bedtime Drift',
              description:
                  'You\'ve been heading to bed 28 minutes later than your ideal window. Consider winding down by 11:20 PM to improve depth.',
              icon: Icons.hourglass_bottom_rounded,
              background: Color(0xFFF1EDFF),
              iconColor: Color(0xFF7760D3),
            ),
            const SizedBox(height: 14),
            const _InsightCard(
              title: 'Movement Alerts',
              description:
                  'Frequent tossing between 2:15–2:50 AM. Guided breathing before bed can help settle your heart rate for deeper phases.',
              icon: Icons.subject_rounded,
              background: Color(0xFFE7F3E5),
              iconColor: FreudColors.mossGreen,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _SecondaryButton(
                    label: 'View History',
                    icon: Icons.bar_chart_rounded,
                    onTap: () => Navigator.of(context)
                        .pushNamed(SleepQualityHistoryScreen.routeName),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PrimaryButton(
                    label: 'Better Sleep Plan',
                    icon: Icons.auto_awesome_rounded,
                    onTap: () => Navigator.of(context)
                        .pushNamed(SleepQualityTipsScreen.routeName),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepSummaryCard extends StatelessWidget {
  const _SleepSummaryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5D3FD3), Color(0xFF8D6CF5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5D3FD3).withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emma Score',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: FreudColors.textLight.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '62',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: FreudColors.textLight,
                        fontSize: 46,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Restless',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: FreudColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_rounded,
                    color: Colors.white, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Your last REM cycle was shortened. Keep consistent lights-out by 11 PM to improve recovery.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreudColors.textLight,
                      height: 1.42,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepMetricTile extends StatelessWidget {
  const _SleepMetricTile({
    required this.label,
    required this.value,
    required this.deltaLabel,
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  final String label;
  final String value;
  final String deltaLabel;
  final IconData icon;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              color: FreudColors.richBrown,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FreudColors.richBrown.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            deltaLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: FreudColors.richBrown.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepStagesChart extends StatelessWidget {
  const _SleepStagesChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _StageLegendDot(color: Color(0xFF6C5BD4), label: 'Deep'),
              const SizedBox(width: 16),
              const _StageLegendDot(color: Color(0xFF8D6CF5), label: 'REM'),
              const SizedBox(width: 16),
              const _StageLegendDot(color: Color(0xFFB5B0FF), label: 'Light'),
              const Spacer(),
              Text(
                '11:02 PM – 6:14 AM',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FreudColors.richBrown.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SizedBox(
            height: 120,
            child: Column(
              children: [
                _StageBarSegment(
                  segments: [
                    _StageSegment(
                        widthFactor: 0.22, color: Color(0xFFB5B0FF)),
                    _StageSegment(
                        widthFactor: 0.18, color: Color(0xFF6C5BD4)),
                    _StageSegment(
                        widthFactor: 0.15, color: Color(0xFF8D6CF5)),
                    _StageSegment(
                        widthFactor: 0.45, color: Color(0xFFB5B0FF)),
                  ],
                  label: '10 PM - 1 AM',
                ),
                SizedBox(height: 14),
                _StageBarSegment(
                  segments: [
                    _StageSegment(
                        widthFactor: 0.18, color: Color(0xFFB5B0FF)),
                    _StageSegment(
                        widthFactor: 0.32, color: Color(0xFF6C5BD4)),
                    _StageSegment(
                        widthFactor: 0.2, color: Color(0xFF8D6CF5)),
                    _StageSegment(
                        widthFactor: 0.3, color: Color(0xFFB5B0FF)),
                  ],
                  label: '1 AM - 4 AM',
                ),
                SizedBox(height: 14),
                _StageBarSegment(
                  segments: [
                    _StageSegment(
                        widthFactor: 0.24, color: Color(0xFFB5B0FF)),
                    _StageSegment(
                        widthFactor: 0.22, color: Color(0xFF8D6CF5)),
                    _StageSegment(
                        widthFactor: 0.18, color: Color(0xFF6C5BD4)),
                    _StageSegment(
                        widthFactor: 0.36, color: Color(0xFFB5B0FF)),
                  ],
                  label: '4 AM - 7 AM',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageLegendDot extends StatelessWidget {
  const _StageLegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FreudColors.richBrown.withValues(alpha: 0.65),
              ),
        ),
      ],
    );
  }
}

class _StageBarSegment extends StatelessWidget {
  const _StageBarSegment({required this.segments, required this.label});

  final List<_StageSegment> segments;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: segments
                    .map(
                      (segment) => Expanded(
                        flex: (segment.widthFactor * 1000).toInt(),
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: segment.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StageSegment {
  const _StageSegment({required this.widthFactor, required this.color});

  final double widthFactor;
  final Color color;
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: FreudColors.richBrown,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.7),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: FreudColors.richBrown,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: FreudColors.richBrown.withValues(alpha: 0.2),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: FreudColors.textLight, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: FreudColors.textLight,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: FreudColors.richBrown.withValues(alpha: 0.14),
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: FreudColors.richBrown, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: FreudColors.richBrown,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
