import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'journal_stats_screen.dart';
import 'journal_detail_screen.dart';
import 'package:get/get.dart';
import '../../Controllers/journal_controller.dart';
import '../../Models/journal_entry.dart';
import 'journal_new_screen.dart';

class JournalOverviewScreen extends StatelessWidget {
  static const routeName = '/journal/overview';
  const JournalOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: FreudColors.richBrown),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text('Health Journal', style: theme.textTheme.displaySmall),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7A4B32), Color(0xFF4B2E21)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetX<JournalController>(
                    builder: (c) {
                      final year = DateTime.now().year;
                      final count = c.entries
                          .where((e) => DateTime.parse(e.date).year == year)
                          .length;
                      return Text('$count',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 64,
                          ));
                    },
                  ),
                  const SizedBox(height: 6),
                  Text('Journals this year.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Journal Statistics',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: FreudColors.richBrown,
                        )),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(JournalStatsScreen.routeName),
                        icon: const Icon(Icons.bar_chart_rounded,
                            color: FreudColors.richBrown),
                        label: Text(
                          'View Stats',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: FreudColors.richBrown,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: FreudColors.richBrown.withValues(alpha: 0.2),
                          ),
                          backgroundColor:
                              FreudColors.richBrown.withValues(alpha: 0.04),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _JournalCalendar(),
                    const SizedBox(height: 16),
                    const Expanded(child: _JournalList()),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(JournalNewScreen.routeName),
                        icon: const Icon(Icons.add),
                        label: const Text('Create Journal'),
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

class _JournalCalendar extends StatelessWidget {
  const _JournalCalendar();

  @override
  Widget build(BuildContext context) {
    return GetX<JournalController>(builder: (c) {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      final map = c.entriesByDateRange(startOfWeek, endOfWeek);
  const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

      Color colorFor(String dateKey) {
        final List<JournalEntry> list = map[dateKey] ?? const <JournalEntry>[];
        if (list.isEmpty) return Colors.grey;
        if (list.any((e) => e.mood == 'negative')) return FreudColors.burntOrange;
        if (list.any((e) => e.mood == 'positive')) return FreudColors.mossGreen;
        // Neutral or drafts with no sentiment
        return FreudColors.paleOlive;
      }

      List<Widget> dots = [];
      for (int i = 0; i < 7; i++) {
        final d = startOfWeek.add(Duration(days: i));
        final key = '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        dots.add(_DotDay(day: labels[i], color: colorFor(key)));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dots,
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 10,
            children: [
              _LegendItem(color: FreudColors.mossGreen, label: 'Positive'),
              _LegendItem(color: FreudColors.burntOrange, label: 'Negative'),
              _LegendItem(color: FreudColors.paleOlive, label: 'Neutral/Draft'),
              _LegendItem(color: Colors.grey, label: 'None'),
            ],
          ),
        ],
      );
    });
  }
}

class _DotDay extends StatelessWidget {
  const _DotDay({required this.day, required this.color});
  final String day;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _JournalList extends StatelessWidget {
  const _JournalList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<JournalController>(builder: (c) {
      final items = [...c.entries];
      if (items.isEmpty) {
        return _EmptyState(onCreate: () => Navigator.of(context).pushNamed(JournalNewScreen.routeName));
      }
      // Sort by latest: date desc then by id desc (creation time-based id)
      items.sort((a, b) {
        final dc = b.date.compareTo(a.date);
        if (dc != 0) return dc;
        return b.id.compareTo(a.id);
      });

      // Group by date
      final groups = <String, List<JournalEntry>>{};
      for (final e in items) {
        (groups[e.date] ??= []).add(e);
      }
      final keys = groups.keys.toList()
        ..sort((a, b) => b.compareTo(a));

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 12),
        itemBuilder: (ctx, idx) {
          final key = keys[idx];
          final date = DateTime.parse(key);
          final label = _formatDayLabel(date);
          final list = groups[key]!..sort((a, b) => b.id.compareTo(a.id));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 8, top: 6),
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ...list.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _JournalItemCard(entry: e),
                  )),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemCount: keys.length,
      );
    });
  }

  String _formatDayLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(d.year, d.month, d.day);
    if (that == today) return 'Today';
    if (that == today.subtract(const Duration(days: 1))) return 'Yesterday';
    const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${w[that.weekday - 1]}, ${m[that.month - 1]} ${that.day}';
  }
}

class _JournalItemCard extends StatelessWidget {
  const _JournalItemCard({required this.entry});
  final JournalEntry entry;

  Color _moodColor() {
    switch (entry.mood) {
      case 'positive':
        return FreudColors.mossGreen;
      case 'negative':
        return FreudColors.burntOrange;
      default:
        return FreudColors.paleOlive;
    }
  }

  String _subtitle() {
    if (entry.type == 'voice') {
      final s = entry.durationSec ?? 0;
      final mm = (s ~/ 60).toString().padLeft(2, '0');
      final ss = (s % 60).toString().padLeft(2, '0');
      return 'Voice • $mm:$ss';
    }
    final text = (entry.content ?? '').trim();
    final preview = text.length > 80 ? '${text.substring(0, 80)}…' : text;
    final words = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    return 'Text • $words words${preview.isEmpty ? '' : ' • $preview'}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = entry.type == 'voice' ? Icons.mic : Icons.edit_note;
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        JournalDetailScreen.routeName,
        arguments: {'id': entry.id},
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: FreudColors.richBrown.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: FreudColors.richBrown.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _moodColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: _moodColor()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.type == 'voice' ? 'Voice Journal' : 'Text Journal',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: FreudColors.richBrown,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _StatusChip(status: entry.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _subtitle(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FreudColors.richBrown.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final isDraft = status != 'published';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDraft ? FreudColors.sunshine.withValues(alpha: 0.12) : FreudColors.mossGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDraft ? FreudColors.sunshine.withValues(alpha: 0.35) : FreudColors.mossGreen.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        isDraft ? 'Draft' : 'Published',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDraft ? FreudColors.richBrown : FreudColors.mossGreen,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: FreudColors.richBrown.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.menu_book_rounded, color: FreudColors.richBrown),
          ),
          const SizedBox(height: 12),
          Text('No journals yet', style: theme.textTheme.bodyLarge?.copyWith(color: FreudColors.richBrown, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Start with a quick text or voice journal.', style: theme.textTheme.bodySmall?.copyWith(color: FreudColors.richBrown.withValues(alpha: 0.7))),
          const SizedBox(height: 16),
          ElevatedButton.icon(onPressed: onCreate, icon: const Icon(Icons.add), label: const Text('Create Journal')),
        ],
      ),
    );
  }
}
