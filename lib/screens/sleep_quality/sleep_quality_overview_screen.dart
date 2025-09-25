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
            const _SleepHighlightStrip(),
            const SizedBox(height: 32),
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

class _SleepHighlightStrip extends StatelessWidget {
  const _SleepHighlightStrip();

  static const _highlights = [
    _HighlightData(
      title: '+5% vs Avg',
      subtitle: 'Deep Sleep quality',
      background: Color(0xFFF0E7FF),
    ),
    _HighlightData(
      title: 'Fell asleep faster',
      subtitle: 'Sleep latency down',
      background: Color(0xFFFFF1DD),
    ),
    _HighlightData(
      title: 'Settled heart rate',
      subtitle: 'Fewer wake-ups',
      background: Color(0xFFE8F5ED),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _highlights
          .map((data) => _SleepHighlightChip(data: data))
          .toList(growable: false),
    );
  }
}

class _SleepHighlightChip extends StatelessWidget {
  const _SleepHighlightChip({required this.data});

  final _HighlightData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 220),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.title,
            style: theme.titleSmall?.copyWith(
              color: FreudColors.richBrown,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.subtitle,
            style: theme.bodySmall?.copyWith(
              color: FreudColors.richBrown.withValues(alpha: 0.65),
              height: 1.3,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _HighlightData {
  const _HighlightData({
    required this.title,
    required this.subtitle,
    required this.background,
  });

  final String title;
  final String subtitle;
  final Color background;
}

class _SleepStagesChart extends StatelessWidget {
  const _SleepStagesChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F1FF),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
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
                children: [
                  for (var i = 0; i < segments.length; i++) ...[
                    Expanded(
                      flex: (segments[i].widthFactor * 1000).round(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          left: i == 0
                              ? const Radius.circular(999)
                              : Radius.zero,
                          right: i == segments.length - 1
                              ? const Radius.circular(999)
                              : Radius.zero,
                        ),
                        child: Container(
                          height: 18,
                          color: segments[i].color,
                        ),
                      ),
                    ),
                    if (i != segments.length - 1)
                      const SizedBox(width: 6),
                  ]
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.65),
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
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: FreudColors.textLight,
                      fontWeight: FontWeight.w700,
                    ),
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
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: FreudColors.richBrown,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
