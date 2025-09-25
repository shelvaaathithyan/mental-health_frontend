import 'package:flutter/material.dart';
import 'package:ai_therapy/core/theme.dart';

class SleepQualityHistoryScreen extends StatelessWidget {
  static const String routeName = '/sleep-quality/history';

  const SleepQualityHistoryScreen({super.key});

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
          'Weekly History',
          style: theme.textTheme.titleLarge?.copyWith(
            color: FreudColors.richBrown,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        children: const [
          _TrendOverview(),
          SizedBox(height: 24),
          _NightCard(
            dateLabel: 'Mon, 20 Jan',
            score: 68,
            status: 'Restless',
            duration: '5h 32m',
            bedtime: '11:24 PM',
            wakeTime: '6:56 AM',
            tags: ['Late caffeine', 'Phones lights'],
          ),
          SizedBox(height: 18),
          _NightCard(
            dateLabel: 'Sun, 19 Jan',
            score: 74,
            status: 'Getting Closer',
            duration: '6h 12m',
            bedtime: '11:02 PM',
            wakeTime: '6:08 AM',
            tags: ['Walked evening', 'Guided breath'],
          ),
          SizedBox(height: 18),
          _NightCard(
            dateLabel: 'Sat, 18 Jan',
            score: 82,
            status: 'Balanced',
            duration: '6h 48m',
            bedtime: '10:54 PM',
            wakeTime: '6:42 AM',
            tags: ['No screens 1h', 'Warm shower'],
          ),
          SizedBox(height: 18),
          _NightCard(
            dateLabel: 'Fri, 17 Jan',
            score: 58,
            status: 'Fragmented',
            duration: '4h 56m',
            bedtime: '12:12 AM',
            wakeTime: '5:48 AM',
            tags: ['Stress rumination'],
          ),
          SizedBox(height: 18),
          _NightCard(
            dateLabel: 'Thu, 16 Jan',
            score: 71,
            status: 'Improving',
            duration: '6h 06m',
            bedtime: '11:10 PM',
            wakeTime: '5:59 AM',
            tags: ['Meditation 10m'],
          ),
        ],
      ),
    );
  }
}

class _TrendOverview extends StatelessWidget {
  const _TrendOverview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trend This Week',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: FreudColors.richBrown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '+12 Neptune Score vs last week',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FreudColors.mossGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E3FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_graph_rounded,
                        color: Color(0xFF6C5BD4), size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '5/7 Nights',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6C5BD4),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _SleepBar(day: 'M', value: 0.62),
                SizedBox(width: 16),
                _SleepBar(day: 'T', value: 0.68),
                SizedBox(width: 16),
                _SleepBar(day: 'W', value: 0.54),
                SizedBox(width: 16),
                _SleepBar(day: 'T', value: 0.74),
                SizedBox(width: 16),
                _SleepBar(day: 'F', value: 0.58),
                SizedBox(width: 16),
                _SleepBar(day: 'S', value: 0.82),
                SizedBox(width: 16),
                _SleepBar(day: 'S', value: 0.71),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepBar extends StatelessWidget {
  const _SleepBar({required this.day, required this.value});

  final String day;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 100 * value,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C5BD4), Color(0xFF8D6CF5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            day,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FreudColors.richBrown.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}

class _NightCard extends StatelessWidget {
  const _NightCard({
    required this.dateLabel,
    required this.score,
    required this.status,
    required this.duration,
    required this.bedtime,
    required this.wakeTime,
    this.tags = const [],
  });

  final String dateLabel;
  final int score;
  final String status;
  final String duration;
  final String bedtime;
  final String wakeTime;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: FreudColors.richBrown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FreudColors.richBrown.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E3FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bed_rounded,
                        color: Color(0xFF6C5BD4), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      score.toString(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6C5BD4),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _InfoChip(label: 'Duration', value: duration),
              const SizedBox(width: 12),
              _InfoChip(label: 'Lights out', value: bedtime),
              const SizedBox(width: 12),
              _InfoChip(label: 'Wake', value: wakeTime),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: FreudColors.cream,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FreudColors.richBrown.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: FreudColors.cream,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
