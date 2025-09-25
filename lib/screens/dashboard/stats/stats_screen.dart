import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  static const String routeName = '/dashboard/stats';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatsHeader(),
              SizedBox(height: 24),
              _ScoreCard(),
              SizedBox(height: 22),
              _MoodHistoryCard(),
              SizedBox(height: 28),
              _SuggestionsCTA(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: FreudColors.richBrown.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.chevron_left, color: FreudColors.richBrown, size: 28),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Freud Score',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: FreudColors.richBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'See your mental score insights',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FreudColors.richBrown.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: FreudColors.richBrown.withValues(alpha: 0.1),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.help_outline_rounded, color: FreudColors.richBrown),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _LegendDot(color: Color(0xFF82B366), label: 'Positive'),
              const SizedBox(width: 16),
              const _LegendDot(color: Color(0xFFF07F45), label: 'Negative'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: const BoxDecoration(
                  color: FreudColors.cream,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month, size: 16, color: FreudColors.richBrown),
                    SizedBox(width: 6),
                    Text(
                      'Monthly',
                      style: TextStyle(
                        color: FreudColors.richBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 150, child: _FreudBarChart()),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('09 Jan', style: theme.textTheme.bodySmall?.copyWith(color: FreudColors.richBrown.withValues(alpha: 0.55))),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: 4,
                  decoration: BoxDecoration(
                    color: FreudColors.richBrown.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: FreudColors.richBrown,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              Text('09 Feb', style: theme.textTheme.bodySmall?.copyWith(color: FreudColors.richBrown.withValues(alpha: 0.55))),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FreudColors.richBrown.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _FreudScoreData {
  const _FreudScoreData({
    required this.positive,
    required this.negative,
  });

  final double positive;
  final double negative;
}

class _FreudBarChart extends StatelessWidget {
  const _FreudBarChart();

  static const _barWidth = 12.0;
  static const _data = <_FreudScoreData>[
    _FreudScoreData(positive: 0.35, negative: 0.1),
    _FreudScoreData(positive: 0.55, negative: 0.08),
    _FreudScoreData(positive: 0.75, negative: 0.12),
    _FreudScoreData(positive: 0.65, negative: 0.18),
    _FreudScoreData(positive: 0.45, negative: 0.05),
    _FreudScoreData(positive: 0.68, negative: 0.0),
    _FreudScoreData(positive: 0.52, negative: 0.0),
    _FreudScoreData(positive: 0.28, negative: 0.35),
    _FreudScoreData(positive: 0.18, negative: 0.42),
    _FreudScoreData(positive: 0.32, negative: 0.16),
    _FreudScoreData(positive: 0.48, negative: 0.06),
    _FreudScoreData(positive: 0.58, negative: 0.04),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBarHeight = constraints.maxHeight - 20;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final value in _data)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: _barWidth,
                    height: maxBarHeight * value.positive,
                    decoration: BoxDecoration(
                      color: const Color(0xFF82B366),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: _barWidth,
                    height: maxBarHeight * value.negative,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF07F45),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _MoodHistoryCard extends StatelessWidget {
  const _MoodHistoryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const moods = [
      _MoodHistoryItem(label: 'Mon', emoji: '😊', color: Color(0xFFFFD27F)),
      _MoodHistoryItem(label: 'Tue', emoji: '😌', color: Color(0xFFAED581)),
      _MoodHistoryItem(label: 'Wed', emoji: '😟', color: Color(0xFFC7C5F3)),
      _MoodHistoryItem(label: 'Thu', emoji: '😐', color: Color(0xFF90CAF9)),
      _MoodHistoryItem(label: 'Fri', emoji: '😡', color: Color(0xFFF48FB1)),
      _MoodHistoryItem(label: 'Sat', emoji: '😑', color: Color(0xFFD7CCC8)),
      _MoodHistoryItem(label: 'Sun', emoji: '🙂', color: Color(0xFFFFF59D)),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Mood History',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: FreudColors.richBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: FreudColors.cream,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_horiz, color: FreudColors.richBrown, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final mood in moods)
                Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: mood.color,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        mood.emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      mood.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FreudColors.richBrown.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoodHistoryItem {
  const _MoodHistoryItem({required this.label, required this.emoji, required this.color});

  final String label;
  final String emoji;
  final Color color;
}

class _SuggestionsCTA extends StatelessWidget {
  const _SuggestionsCTA();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: FreudColors.richBrown,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cyclone_rounded, color: FreudColors.textLight),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Swipe for AI suggestions',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: FreudColors.textLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: FreudColors.textLight),
        ],
      ),
    );
  }
}
