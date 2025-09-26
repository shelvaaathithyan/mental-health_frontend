import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme.dart';
import '../screens/dashboard/widgets/freud_bottom_navbar.dart';
import '../screens/mindful_hours/mindful_hours_screen.dart';
import '../screens/sleep_quality/sleep_quality_overview_screen.dart';
import '../screens/therapy_chatbot/therapy_chatbot_screen.dart';
import '../screens/journal/journal_new_screen.dart';
import '../screens/mood_tracker/mood_tracker_screen.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/dashboard';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FreudColors.cream,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FreudBottomNavbar(
          items: const [
            FreudBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
            FreudBottomNavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
            FreudBottomNavItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
            FreudBottomNavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
          ],
          currentIndex: _navIndex,
          onItemSelected: (index) {
            setState(() => _navIndex = index);
            switch (index) {
              case 0:
                // Home tab (stay on HomeView)
                break;
              case 1:
                // Chat tab
                Get.toNamed(TherapyChatbotScreen.routeName);
                break;
              case 2:
                // Stats tab
                Get.toNamed('/dashboard/stats');
                break;
              case 3:
                // Profile tab
                Get.toNamed('/profile');
                break;
            }
          },
          onCenterTap: () {
            Get.toNamed(JournalNewScreen.routeName);
          },
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeHeader(),
              SizedBox(height: 24),
              _MindfulTrackerSection(),
              SizedBox(height: 24),
              _MindfulJourneyButton(),
              SizedBox(height: 24),
              _ChatbotSection(),
              SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: const BoxDecoration(
        color: FreudColors.richBrown,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      color: FreudColors.textLight, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Tue, 25 Jan 2025',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreudColors.textLight.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: FreudColors.burntOrange.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: FreudColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/robot.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Shinomiya!',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: FreudColors.textLight,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ProfileTag(
                          icon: Icons.star,
                          label: 'Pro',
                          color: FreudColors.mossGreen,
                        ),
                        _ProfileTag(
                          icon: Icons.local_florist,
                          label: '80%',
                          color: FreudColors.burntOrange,
                        ),
                        _ProfileTag(
                          icon: Icons.emoji_emotions_outlined,
                          label: 'Happy',
                          color: FreudColors.sunshine,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SearchBar(),
        ],
      ),
    );
  }
}
class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FreudColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Search anything...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FreudColors.textDark.withValues(alpha: 0.35),
                  ),
            ),
          ),
          const Icon(Icons.search, color: FreudColors.richBrown, size: 22),
        ],
      ),
    );
  }
}

class _MindfulTrackerSection extends StatelessWidget {
  const _MindfulTrackerSection();

  static const _cardSpacing = 18.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Mindful Tracker',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: FreudColors.richBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: FreudColors.richBrown,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _TrackerCard(
            background: const Color(0xFFE7F3E5),
            iconColor: FreudColors.mossGreen,
            icon: Icons.local_florist_rounded,
            title: 'Mindful Hours',
            subtitle: '2.5h/8h Today',
            trailing: const _MindfulHoursSparkline(),
            onTap: () {
              Navigator.of(context).pushNamed(MindfulHoursScreen.routeName);
            },
          ),
          const SizedBox(height: _cardSpacing),
          _TrackerCard(
            background: const Color(0xFFF1EDFF),
            iconColor: const Color(0xFF7760D3),
            icon: Icons.nights_stay_rounded,
            title: 'Sleep Quality',
            subtitle: 'Insomniac (~2h Avg)',
            trailing: const _SleepQualityRing(value: 0.2, label: '20'),
            onTap: () => Navigator.of(context)
                .pushNamed(SleepQualityOverviewScreen.routeName),
          ),
          const SizedBox(height: _cardSpacing),
          _TrackerCard(
            background: const Color(0xFFFDEBE0),
            iconColor: FreudColors.burntOrange,
            icon: Icons.menu_book_rounded,
            title: 'Mindful Journal',
            subtitle: '64 Day Streak',
            trailing: const _JournalHeatmap(),
            onTap: () => Get.toNamed(JournalNewScreen.routeName),
          ),
          const SizedBox(height: _cardSpacing),
          _TrackerCard(
            background: const Color(0xFFFFF3DF),
            iconColor: const Color(0xFFE4A03E),
            icon: Icons.emoji_people_rounded,
            title: 'Stress Level',
            subtitle: 'Level 3 (Normal)',
            trailing: const _StressLevelBar(level: 3, totalLevels: 5),
            onTap: () => Get.toNamed('/stress/overview'),
          ),
          const SizedBox(height: _cardSpacing),
          const _MoodTrackerCard(),
        ],
      ),
    );
  }
}

class _MindfulJourneyButton extends StatelessWidget {
  const _MindfulJourneyButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(MindfulHoursScreen.routeName),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF3D2418),
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: FreudColors.richBrown.withValues(alpha: 0.28),
                blurRadius: 22,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.cyclone_rounded,
                    color: FreudColors.textLight, size: 22),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mindful Journey',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: FreudColors.textLight,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'See detailed hours and stats',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: FreudColors.textLight.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: FreudColors.textLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: FreudColors.richBrown,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackerCard extends StatelessWidget {
  const _TrackerCard({
    required this.background,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailing,
    this.subtitle,
    this.onTap,
  });

  final Color background;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _TrackerIconBadge(icon: icon, color: iconColor),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: FreudColors.richBrown,
                  ),
                ),
                const SizedBox(height: 8),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FreudColors.richBrown.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
    if (onTap == null) {
      return card;
    }
    return GestureDetector(onTap: onTap, child: card);
  }
}

class _TrackerIconBadge extends StatelessWidget {
  const _TrackerIconBadge({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}

class _MindfulHoursSparkline extends StatelessWidget {
  const _MindfulHoursSparkline();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(64, 48),
      painter: _SparklinePainter(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final points = [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.35),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.25),
      Offset(size.width, size.height * 0.55),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final paint = Paint()
      ..color = FreudColors.mossGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final shadowPaint = Paint()
      ..color = FreudColors.mossGreen.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SleepQualityRing extends StatelessWidget {
  const _SleepQualityRing({
    required this.value,
    required this.label,
  });

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7760D3)),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7760D3),
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _JournalHeatmap extends StatelessWidget {
  const _JournalHeatmap();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(12, (index) {
          final isFilled = index < 9;
          return Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isFilled
                  ? FreudColors.burntOrange.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class _StressLevelBar extends StatelessWidget {
  const _StressLevelBar({
    required this.level,
    required this.totalLevels,
  });

  final int level;
  final int totalLevels;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalLevels, (index) {
        final isActive = index < level;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 14,
            height: 36,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFE4A03E)
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }),
    );
  }
}

class _MoodTrackerFlow extends StatelessWidget {
  const _MoodTrackerFlow();

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'label': 'Sad', 'color': const Color(0xFFE06C5F)},
      {'label': 'Happy', 'color': FreudColors.mossGreen},
      {'label': 'Neutral', 'color': const Color(0xFFD9CFC0)},
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < moods.length; i++) ...[
          _MoodChip(
            label: moods[i]['label']! as String,
            color: moods[i]['color']! as Color,
          ),
          if (i != moods.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: FreudColors.richBrown.withValues(alpha: 0.3),
              ),
            ),
        ],
      ],
    );
  }
}

class _MoodTrackerCard extends StatelessWidget {
  const _MoodTrackerCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed(MoodTrackerScreen.routeName),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F1),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TrackerIconBadge(
                  icon: Icons.mood_rounded,
                  color: Color(0xFFB08B6C),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    'Mood\nTracker',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: FreudColors.richBrown,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _MoodTrackerFlow(),
          ],
        ),
      ),
    );
  }
}

class _ChatbotSection extends StatelessWidget {
  const _ChatbotSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;
          final rawWidth = constraints.maxWidth * (isCompact ? 0.48 : 0.32);
          final robotWidth = rawWidth.clamp(80.0, 120.0).toDouble();
          final robotHeight = robotWidth * 1.25;

          final statsContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'AI Therapy Chatbot',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: FreudColors.textLight,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: FreudColors.textLight,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '2,541',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: FreudColors.textLight,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.messenger_outline,
                      color: FreudColors.textLight, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '83 left this month',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreudColors.textLight.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.workspace_premium_outlined,
                      color: FreudColors.textLight, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Go Pro, now!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreudColors.textLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          );

          final robotImage = SizedBox(
            width: robotWidth,
            height: robotHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/robot.png',
                fit: BoxFit.cover,
              ),
            ),
          );

          final content = isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    statsContent,
                    const SizedBox(height: 20),
                    Align(alignment: Alignment.center, child: robotImage),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: statsContent),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: robotImage,
                      ),
                    ),
                  ],
                );

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 54),
                decoration: BoxDecoration(
                  color: const Color(0xFFBDB3AA),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: content,
              ),
              if (isCompact)
                const Positioned(
                  bottom: -26,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ChatbotActionButton(
                        color: FreudColors.mossGreen,
                        icon: Icons.add,
                      ),
                      SizedBox(width: 32),
                      _ChatbotActionButton(
                        color: FreudColors.burntOrange,
                        icon: Icons.settings_applications_rounded,
                      ),
                    ],
                  ),
                )
              else ...const [
                Positioned(
                  bottom: -26,
                  left: 32,
                  child: _ChatbotActionButton(
                    color: FreudColors.mossGreen,
                    icon: Icons.add,
                  ),
                ),
                Positioned(
                  bottom: -26,
                  left: 104,
                  child: _ChatbotActionButton(
                    color: FreudColors.burntOrange,
                    icon: Icons.settings_applications_rounded,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ChatbotActionButton extends StatelessWidget {
  const _ChatbotActionButton({
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: FreudColors.textLight, size: 24),
    );
  }
}


