import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'mindful_hours_stats_screen.dart';

class MindfulHoursScreen extends StatelessWidget {
  const MindfulHoursScreen({super.key});

  static const String routeName = '/mindful-hours';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FreudColors.richBrown,
      body: Stack(
        children: [
          _MindfulBackground(),
          SafeArea(child: _MindfulContent()),
        ],
      ),
    );
  }
}

class _MindfulBackground extends StatelessWidget {
  const _MindfulBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4B3A2F), Color(0xFF35271E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -20,
            child: _BackdropShape(
              width: 180,
              height: 180,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            top: 120,
            right: -40,
            child: _BackdropShape(
              width: 140,
              height: 140,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -60,
            child: _BackdropShape(
              width: 220,
              height: 220,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropShape extends StatelessWidget {
  const _BackdropShape({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height * 0.45),
      ),
    );
  }
}

class _MindfulContent extends StatelessWidget {
  const _MindfulContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              _CircleIconButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 16),
              Text(
                'Mindful Hours',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: FreudColors.textLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _CircleIconButton(
                icon: Icons.more_horiz,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              Text(
                '5.21',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: FreudColors.textLight,
                  fontSize: 80,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mindful Hours',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: FreudColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const _MindfulHistoryCard(),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: FreudColors.textLight, size: 18),
      ),
    );
  }
}

class _MindfulHistoryCard extends StatelessWidget {
  const _MindfulHistoryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const sessions = <MindfulSession>[
      MindfulSession(
        title: 'Deep Meditation',
        label: 'Nature',
        elapsed: '05:02',
        duration: '25:00',
      ),
      MindfulSession(
        title: 'Relaxed State',
        label: 'Chirping Bird',
        elapsed: '08:33',
        duration: '60:00',
      ),
      MindfulSession(
        title: 'Deep Breathing',
        label: 'Ocean',
        elapsed: '12:45',
        duration: '45:00',
      ),
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: FreudColors.textLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mindful Hour History',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: FreudColors.richBrown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz,
                        color: FreudColors.richBrown),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              for (final session in sessions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _MindfulSessionTile(session: session),
                ),
            ],
          ),
        ),
        Positioned(
          top: -32,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(MindfulHoursStatsScreen.routeName);
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: FreudColors.richBrown,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: FreudColors.richBrown.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: FreudColors.textLight,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MindfulSession {
  const MindfulSession({
    required this.title,
    required this.label,
    required this.elapsed,
    required this.duration,
  });

  final String title;
  final String label;
  final String elapsed;
  final String duration;
}

class _MindfulSessionTile extends StatelessWidget {
  const _MindfulSessionTile({required this.session});

  final MindfulSession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: FreudColors.richBrown.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: FreudColors.richBrown),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      session.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: FreudColors.richBrown,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _SessionPill(label: session.label),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      session.elapsed,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FreudColors.richBrown.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ProgressBar(
                        progress: _calculateProgress(session.elapsed, session.duration),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      session.duration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FreudColors.richBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProgress(String elapsed, String duration) {
    double toMinutes(String value) {
      final parts = value.split(':');
      if (parts.length != 2) return 0;
      final minutes = double.tryParse(parts[0]) ?? 0;
      final seconds = double.tryParse(parts[1]) ?? 0;
      return minutes + seconds / 60;
    }

    final elapsedMinutes = toMinutes(elapsed);
    final durationMinutes = toMinutes(duration);
    if (durationMinutes == 0) return 0;
    return (elapsedMinutes / durationMinutes).clamp(0, 1);
  }
}

class _SessionPill extends StatelessWidget {
  const _SessionPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FreudColors.mossGreen.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: FreudColors.mossGreen,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: FreudColors.richBrown.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                color: FreudColors.richBrown,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        },
      ),
    );
  }
}
