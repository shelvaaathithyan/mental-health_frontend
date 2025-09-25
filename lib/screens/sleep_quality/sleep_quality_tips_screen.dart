import 'package:flutter/material.dart';
import 'package:ai_therapy/core/theme.dart';
import 'sleep_quality_history_screen.dart';

class SleepQualityTipsScreen extends StatelessWidget {
  static const String routeName = '/sleep-quality/tips';

  const SleepQualityTipsScreen({super.key});

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
          'Better Sleep Plan',
          style: theme.textTheme.titleLarge?.copyWith(
            color: FreudColors.richBrown,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _RoutineBanner(),
            const SizedBox(height: 24),
            Text(
              'Tonight\'s Checklist',
              style: theme.textTheme.titleMedium?.copyWith(
                color: FreudColors.richBrown,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            const _ChecklistItem(
              icon: Icons.dark_mode_rounded,
              title: 'Wind-down ritual',
              description: 'Dim lights, read physical pages, and start lavender diffuser by 10:45 PM.',
            ),
            const SizedBox(height: 14),
            const _ChecklistItem(
              icon: Icons.motion_photos_pause_rounded,
              title: 'Breathing circuit',
              description: '4-7-8 pattern for three rounds to slow heart rate before sleep latency.',
            ),
            const SizedBox(height: 14),
            const _ChecklistItem(
              icon: Icons.local_drink_rounded,
              title: 'Hydration window',
              description: 'Wrap fluids by 9:45 PM to reduce 2 AM wake-ups. Sip warm chamomile instead.',
            ),
            const SizedBox(height: 28),
            Text(
              'Micro-adjustments',
              style: theme.textTheme.titleMedium?.copyWith(
                color: FreudColors.richBrown,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            const _AdjustmentCard(
              title: 'Bedroom temperature',
              description: 'Lower thermostat to 20°C and keep blackout curtains drawn 1 hr before bed.',
              icon: Icons.ac_unit_rounded,
              background: Color(0xFFD5F3EA),
            ),
            const SizedBox(height: 16),
            const _AdjustmentCard(
              title: 'Screens & blue light',
              description: 'Enable night shift on all devices and set “Do Not Disturb” by 10:15 PM nightly.',
              icon: Icons.phone_android_rounded,
              background: Color(0xFFFDEBE0),
            ),
            const SizedBox(height: 16),
            const _AdjustmentCard(
              title: 'Morning sunlight',
              description: 'Step outside for 8 minutes between 7:30–8:00 AM to anchor your circadian rhythm.',
              icon: Icons.wb_sunny_rounded,
              background: Color(0xFFFFF3DF),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(22),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E3FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.bar_chart_rounded,
                        color: Color(0xFF6C5BD4), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Track progress',
                          style: theme.textTheme.titleSmall?.copyWith(
                                color: FreudColors.richBrown,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Review bedtime trends across the week to see patterns. You\'re just three consistent nights from steady recovery.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                                color: FreudColors.richBrown.withValues(alpha: 0.68),
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(SleepQualityHistoryScreen.routeName),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5D3FD3), Color(0xFF8D6CF5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5D3FD3).withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timeline_rounded,
                        color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      'Review Weekly Rhythm',
                      style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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

class _RoutineBanner extends StatelessWidget {
  const _RoutineBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D2418), Color(0xFF4F2F1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Neptune Routine',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FreudColors.textLight.withValues(alpha: 0.74),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stabilize your rhythm in 7 nights',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: FreudColors.textLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We\'ve mapped a gentle sleep routine that balances cortisol and melatonin peaks. Follow each micro-step and we\'ll adapt nightly.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FreudColors.textLight,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.self_improvement_rounded,
                color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FreudColors.cream,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: FreudColors.richBrown, size: 22),
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
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.68),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: FreudColors.richBrown.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.check_rounded,
                color: FreudColors.mossGreen, size: 20),
          ),
        ],
      ),
    );
  }
}

class _AdjustmentCard extends StatelessWidget {
  const _AdjustmentCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.background,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
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
            child: Icon(icon, color: FreudColors.richBrown, size: 22),
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
