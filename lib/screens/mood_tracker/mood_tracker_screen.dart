import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  static const String routeName = '/mood-tracker';

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  static const List<String> _periods = [
    '1 Day',
    '1 Week',
    '1 Month',
    '1 Year',
    'All Time',
  ];

  int _selectedPeriodIndex = 1;
  String _selectedMonth = 'January';
  late List<MoodPoint> _weekData;
  late List<MoodHistoryEntry> _history;

  @override
  void initState() {
    super.initState();
    _weekData = _buildSampleWeekData();
    _history = _buildSampleHistory();
  }

  List<MoodPoint> _buildSampleWeekData() {
    return [
      MoodPoint(
        day: 'Mon',
        value: kMoodSequence[4].curveValue,
        mood: kMoodSequence[4],
        showLabel: true,
      ),
      MoodPoint(day: 'Tue', value: kMoodSequence[1].curveValue, mood: kMoodSequence[1]),
      MoodPoint(day: 'Wed', value: kMoodSequence[2].curveValue, mood: kMoodSequence[2]),
      MoodPoint(
        day: 'Thu',
        value: kMoodSequence[0].curveValue,
        mood: kMoodSequence[0],
        showLabel: true,
        labelSide: MoodLabelSide.below,
      ),
      MoodPoint(day: 'Fri', value: kMoodSequence[3].curveValue, mood: kMoodSequence[3]),
      MoodPoint(day: 'Sat', value: 0.78, mood: kMoodSequence[3], showLabel: true),
      MoodPoint(day: 'Sun', value: kMoodSequence[4].curveValue, mood: kMoodSequence[4]),
    ];
  }

  List<MoodHistoryEntry> _buildSampleHistory() {
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final moods = [
      kMoodSequence[4],
      kMoodSequence[3],
      kMoodSequence[1],
      kMoodSequence[0],
      kMoodSequence[2],
      kMoodSequence[3],
      kMoodSequence[4],
    ];
    return List.generate(labels.length, (index) {
      return MoodHistoryEntry(day: labels[index], mood: moods[index]);
    });
  }

  void _selectPeriod(int index) {
    setState(() => _selectedPeriodIndex = index);
  }

  Future<void> _openMoodInput() async {
    final initialMood = _history.last.mood;
    final result = await Navigator.of(context).push<MoodDefinition>(
      MaterialPageRoute(
        builder: (_) => MoodInputScreen(initialMood: initialMood),
      ),
    );
    if (result != null) {
      _applyMood(result);
    }
  }

  void _applyMood(MoodDefinition mood) {
    final lastHistory = _history.last;
    _history[_history.length - 1] =
        MoodHistoryEntry(day: lastHistory.day, mood: mood);
    _weekData[_weekData.length - 1] =
        _weekData.last.copyWith(mood: mood, value: mood.curveValue, showLabel: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const SizedBox(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF4E6), Color(0xFFFDEFE3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mood Stats',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: FreudColors.richBrown,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'See your mood throughout the day.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 20),
                _MoodPeriodSelector(
                  periods: _periods,
                  selectedIndex: _selectedPeriodIndex,
                  onSelected: _selectPeriod,
                ),
                const SizedBox(height: 24),
                _MoodTimelineCard(data: _weekData),
                const SizedBox(height: 28),
                _MoodHistoryCard(
                  history: _history,
                  selectedMonth: _selectedMonth,
                  onMonthChanged: (value) {
                    setState(() => _selectedMonth = value);
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: FreudColors.mossGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      textStyle: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: FreudColors.textLight,
                      ),
                    ),
                    onPressed: _openMoodInput,
                    icon: const Icon(Icons.add_rounded, color: FreudColors.textLight),
                    label: const Text('Log today\'s mood'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodPeriodSelector extends StatelessWidget {
  const _MoodPeriodSelector({
    required this.periods,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(periods.length, (index) {
        final isActive = selectedIndex == index;
        return GestureDetector(
          onTap: () => onSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? FreudColors.richBrown : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isActive
                    ? Colors.transparent
                    : FreudColors.richBrown.withValues(alpha: 0.1),
              ),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: FreudColors.richBrown.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: Text(
              periods[index],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive ? FreudColors.textLight : FreudColors.richBrown,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        );
      }),
    );
  }
}

class _MoodArcSelector extends StatelessWidget {
  const _MoodArcSelector({
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const horizontalInset = 36.0;
        final maxRadius = (width / 2) - horizontalInset;
        final radius = math.max(150.0, math.min(width * 0.45, maxRadius));
        final centerY = radius + 52;
        final height = centerY + 48;
        final center = Offset(width / 2, centerY);
        const hitSize = 80.0;

        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _ArcTrackPainter(
                    center: center,
                    radius: radius,
                    activeIndex: selectedIndex,
                  ),
                ),
              ),
              for (var index = 0; index < kMoodSequence.length; index++)
                _ArcDot(
                  index: index,
                  center: center,
                  radius: radius,
                  isActive: index == selectedIndex,
                  hitSize: hitSize,
                  onTap: () => onSelect(index),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ArcTrackPainter extends CustomPainter {
  const _ArcTrackPainter({
    required this.center,
    required this.radius,
    required this.activeIndex,
  });

  final Offset center;
  final double radius;
  final int activeIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    final basePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, basePaint);

    if (activeIndex > 0) {
      final sweepPerSegment = math.pi / (kMoodSequence.length - 1);
      final highlightPaint = Paint()
        ..shader = const LinearGradient(
          colors: [Colors.white, Color(0xCCFFFFFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(rect)
        ..strokeWidth = 14
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        math.pi,
        sweepPerSegment * activeIndex,
        false,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArcTrackPainter oldDelegate) {
    return oldDelegate.center != center ||
        oldDelegate.radius != radius ||
        oldDelegate.activeIndex != activeIndex;
  }
}

class _ArcDot extends StatelessWidget {
  const _ArcDot({
    required this.index,
    required this.center,
    required this.radius,
    required this.isActive,
    required this.hitSize,
    required this.onTap,
  });

  final int index;
  final Offset center;
  final double radius;
  final bool isActive;
  final double hitSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final step = math.pi / (kMoodSequence.length - 1);
    final angle = math.pi + (step * index);
    final position = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    final mood = kMoodSequence[index];

    final outerSize = isActive ? 44.0 : 28.0;
    final innerSize = isActive ? 22.0 : 12.0;

    return Positioned(
      left: position.dx - (hitSize / 2),
      top: position.dy - (hitSize / 2),
      width: hitSize,
      height: hitSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          alignment: Alignment.center,
          child: Container(
            width: outerSize,
            height: outerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: isActive ? 0.95 : 0.35),
              border: Border.all(
                color: Colors.white.withValues(alpha: isActive ? 0 : 0.18),
                width: 2,
              ),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: mood.badgeBorder.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  color: isActive
                      ? mood.badgeBorder
                      : Colors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodTimelineCard extends StatelessWidget {
  const _MoodTimelineCard({required this.data});

  final List<MoodPoint> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stacked_line_chart_rounded,
                  color: FreudColors.richBrown.withValues(alpha: 0.7)),
              const SizedBox(width: 10),
              Text(
                '1 Week',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FreudColors.richBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartSize = constraints.biggest;
                final points = _resolveOffsets(data, chartSize);
                return Stack(
                  children: [
                    CustomPaint(
                      size: constraints.biggest,
                      painter: _MoodCurvePainter(points: points),
                    ),
                    ..._buildMoodTags(points, data, chartSize),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data
                .map((point) => Expanded(
                      child: Text(
                        point.day,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FreudColors.richBrown.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMoodTags(
    List<_CurvePoint> points,
    List<MoodPoint> data,
    Size canvasSize,
  ) {
    final List<Widget> tags = [];
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      if (!item.showLabel) continue;
      final point = points[i];
      final isBelow = item.labelSide == MoodLabelSide.below;
      final horizontalCenter = point.offset.dx - 42;
      final clampedLeft = horizontalCenter.clamp(8.0, canvasSize.width - 84);
      final top = isBelow
          ? math.min(point.offset.dy + 20, canvasSize.height - 54)
          : math.max(point.offset.dy - 96, 0.0);

      tags.add(
        Positioned(
          left: clampedLeft,
          top: top,
          child: _MoodBadge(
            mood: item.mood,
            side: item.labelSide,
          ),
        ),
      );
    }
    return tags;
  }
}

class _MoodBadge extends StatelessWidget {
  const _MoodBadge({
    required this.mood,
    this.side = MoodLabelSide.above,
  });

  final MoodDefinition mood;
  final MoodLabelSide side;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: mood.badgeBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: mood.badgeBorder, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: mood.badgeBorder.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mood.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            mood.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: mood.badgeTextColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );

    final pointer = _MoodBadgePointer(
      color: mood.badgeBackground,
      borderColor: mood.badgeBorder,
      side: side,
    );

    if (side == MoodLabelSide.above) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bubble,
          const SizedBox(height: 4),
          pointer,
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        pointer,
        const SizedBox(height: 4),
        bubble,
      ],
    );
  }
}

class _MoodBadgePointer extends StatelessWidget {
  const _MoodBadgePointer({
    required this.color,
    required this.borderColor,
    required this.side,
  });

  final Color color;
  final Color borderColor;
  final MoodLabelSide side;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(16, 10),
      painter: _MoodBadgePointerPainter(
        color: color,
        borderColor: borderColor,
        side: side,
      ),
    );
  }
}

class _MoodBadgePointerPainter extends CustomPainter {
  const _MoodBadgePointerPainter({
    required this.color,
    required this.borderColor,
    required this.side,
  });

  final Color color;
  final Color borderColor;
  final MoodLabelSide side;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (side == MoodLabelSide.above) {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }
    path.close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _MoodBadgePointerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.side != side;
  }
}

class _MoodHistoryCard extends StatelessWidget {
  const _MoodHistoryCard({
    required this.history,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  final List<MoodHistoryEntry> history;
  final String selectedMonth;
  final ValueChanged<String> onMonthChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood History',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: FreudColors.richBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMonth,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: FreudColors.richBrown),
                  borderRadius: BorderRadius.circular(20),
                  items: const [
                    DropdownMenuItem(value: 'January', child: Text('January')),
                    DropdownMenuItem(value: 'February', child: Text('February')),
                    DropdownMenuItem(value: 'March', child: Text('March')),
                  ],
                  onChanged: (value) {
                    if (value != null) onMonthChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: history
                .map((entry) => Expanded(
                      child: _MoodHistoryPill(entry: entry),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MoodHistoryPill extends StatelessWidget {
  const _MoodHistoryPill({required this.entry});

  final MoodHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: entry.mood.historyBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(entry.mood.emoji, style: const TextStyle(fontSize: 22)),
        ),
        const SizedBox(height: 8),
        Text(
          entry.day,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FreudColors.richBrown,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _MoodCurvePainter extends CustomPainter {
  const _MoodCurvePainter({required this.points});

  final List<_CurvePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final gridPaint = Paint()
      ..color = const Color(0xFFE7DCCA)
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final dy = size.height * (i / 4);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    final path = Path()..moveTo(points.first.offset.dx, points.first.offset.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i].offset;
      final next = points[i + 1].offset;
      final controlPoint = Offset(
        (current.dx + next.dx) / 2,
        current.dy,
      );
      path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, next.dx, next.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.offset.dx, size.height)
      ..lineTo(points.first.offset.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEED7BE), Color(0xFFF7ECE0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF8E5C41)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFF8E5C41);

    for (final point in points) {
      canvas.drawCircle(point.offset, 5.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoodCurvePainter oldDelegate) => !listEquals(oldDelegate.points, points);
}

List<_CurvePoint> _resolveOffsets(List<MoodPoint> data, Size size) {
  final points = <_CurvePoint>[];
  if (data.isEmpty) {
    return points;
  }
  final stepX = size.width / (data.length - 1);
  for (var i = 0; i < data.length; i++) {
    final normalized = data[i].value.clamp(0.0, 1.0);
    final dx = stepX * i;
    final dy = size.height - (normalized * size.height);
    points.add(_CurvePoint(index: i, offset: Offset(dx, dy)));
  }
  return points;
}

class MoodInputScreen extends StatefulWidget {
  MoodInputScreen({super.key, MoodDefinition? initialMood})
      : initialMood = initialMood ?? kMoodSequence.first;

  final MoodDefinition initialMood;

  @override
  State<MoodInputScreen> createState() => _MoodInputScreenState();
}

class _MoodInputScreenState extends State<MoodInputScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = kMoodSequence.indexWhere((mood) => mood.id == widget.initialMood.id);
    if (_selectedIndex == -1) {
      _selectedIndex = 0;
    }
  }

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
  }

  void _submit() {
    Navigator.of(context).pop(kMoodSequence[_selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final mood = kMoodSequence[_selectedIndex];
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: mood.background,
      body: Container(
        decoration: BoxDecoration(gradient: mood.fullscreenGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'How are you feeling\nthis day?',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 64),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "I'm Feeling ${mood.label}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: _MoodArcSelector(
                  selectedIndex: _selectedIndex,
                  onSelect: _onSelect,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: mood.buttonTextColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      textStyle: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Set Mood  ✓'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MoodHistoryEntry {
  MoodHistoryEntry({required this.day, required this.mood});

  final String day;
  final MoodDefinition mood;
}

enum MoodLabelSide { above, below }

class MoodPoint {
  const MoodPoint({
    required this.day,
    required this.value,
    required this.mood,
    this.showLabel = false,
    this.labelSide = MoodLabelSide.above,
  });

  final String day;
  final double value;
  final MoodDefinition mood;
  final bool showLabel;
  final MoodLabelSide labelSide;

  MoodPoint copyWith({
    double? value,
    MoodDefinition? mood,
    bool? showLabel,
    MoodLabelSide? labelSide,
  }) {
    return MoodPoint(
      day: day,
      value: value ?? this.value,
      mood: mood ?? this.mood,
      showLabel: showLabel ?? this.showLabel,
      labelSide: labelSide ?? this.labelSide,
    );
  }
}

class _CurvePoint {
  const _CurvePoint({required this.index, required this.offset});

  final int index;
  final Offset offset;

  @override
  bool operator ==(Object other) {
    return other is _CurvePoint &&
        other.index == index &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(index, offset);
}

class MoodDefinition {
  const MoodDefinition({
    required this.id,
    required this.label,
    required this.emoji,
    required this.background,
    required this.fullscreenGradient,
    required this.badgeBackground,
    required this.badgeBorder,
    required this.badgeTextColor,
    required this.historyBackground,
    required this.buttonTextColor,
    required this.curveValue,
  });

  final String id;
  final String label;
  final String emoji;
  final Color background;
  final Gradient fullscreenGradient;
  final Color badgeBackground;
  final Color badgeBorder;
  final Color badgeTextColor;
  final Color historyBackground;
  final Color buttonTextColor;
  final double curveValue;
}

const List<MoodDefinition> kMoodSequence = [
  MoodDefinition(
    id: 'depressed',
    label: 'Depressed',
    emoji: '😞',
    background: Color(0xFF9A88F4),
    fullscreenGradient: LinearGradient(
      colors: [Color(0xFF9A88F4), Color(0xFF6F5BD4)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    badgeBackground: Color(0xFFFFE6D6),
    badgeBorder: Color(0xFFEC8A3F),
    badgeTextColor: Color(0xFFEC8A3F),
    historyBackground: Color(0xFFFFE4D8),
    buttonTextColor: Color(0xFF3D2A6B),
    curveValue: 0.25,
  ),
  MoodDefinition(
    id: 'sad',
    label: 'Sad',
    emoji: '🙁',
    background: Color(0xFFDF7C2E),
    fullscreenGradient: LinearGradient(
      colors: [Color(0xFFFFAE59), Color(0xFFDF7C2E)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    badgeBackground: Color(0xFFFFE3CC),
    badgeBorder: Color(0xFFDE7A2D),
    badgeTextColor: Color(0xFFDE7A2D),
    historyBackground: Color(0xFFFFE0CB),
    buttonTextColor: Color(0xFF5E2C0B),
    curveValue: 0.38,
  ),
  MoodDefinition(
    id: 'anxious',
    label: 'Anxious',
    emoji: '😰',
    background: Color(0xFF5E9CA4),
    fullscreenGradient: LinearGradient(
      colors: [Color(0xFF6BB7BA), Color(0xFF3F7D86)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    badgeBackground: Color(0xFFE2F4F6),
    badgeBorder: Color(0xFF4E8F96),
    badgeTextColor: Color(0xFF3F7D86),
    historyBackground: Color(0xFFDFF0F2),
    buttonTextColor: Color(0xFF1F4D52),
    curveValue: 0.48,
  ),
  MoodDefinition(
    id: 'neutral',
    label: 'Neutral',
    emoji: '😐',
    background: Color(0xFF9A7A64),
    fullscreenGradient: LinearGradient(
      colors: [Color(0xFFB7977E), Color(0xFF7D5E49)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    badgeBackground: Color(0xFFEBDCCD),
    badgeBorder: Color(0xFF8F6D53),
    badgeTextColor: Color(0xFF5E412D),
    historyBackground: Color(0xFFE8D7C6),
    buttonTextColor: Color(0xFF3A2515),
    curveValue: 0.6,
  ),
  MoodDefinition(
    id: 'happy',
    label: 'Happy',
    emoji: '🙂',
    background: Color(0xFFFAD171),
    fullscreenGradient: LinearGradient(
      colors: [Color(0xFFFFE08D), Color(0xFFF8C957)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    badgeBackground: Color(0xFFFFF3CD),
    badgeBorder: Color(0xFFF3B23C),
    badgeTextColor: Color(0xFFAD6D04),
    historyBackground: Color(0xFFFFF0C6),
    buttonTextColor: Color(0xFF7A5000),
    curveValue: 0.72,
  ),
  MoodDefinition(
    id: 'overjoyed',
    label: 'Overjoyed',
    emoji: '😁',
    background: Color(0xFFA8C86F),
    fullscreenGradient: LinearGradient(
      colors: [Color(0xFFB7DD84), Color(0xFF89B64F)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    badgeBackground: Color(0xFFE6F3D3),
    badgeBorder: Color(0xFF7BA94B),
    badgeTextColor: Color(0xFF49691F),
    historyBackground: Color(0xFFE2F2CF),
    buttonTextColor: Color(0xFF2F4E0F),
    curveValue: 0.85,
  ),
];
