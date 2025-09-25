import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme.dart';
import '../../Controllers/journal_controller.dart';
import '../../Models/journal_entry.dart';

class JournalDetailScreen extends StatelessWidget {
  static const routeName = '/journal/detail';
  const JournalDetailScreen({super.key});

  Color _moodColor(String mood) {
    switch (mood) {
      case 'positive':
        return FreudColors.mossGreen;
      case 'negative':
        return FreudColors.burntOrange;
      default:
        return FreudColors.paleOlive;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final id = Get.arguments is Map ? (Get.arguments['id'] as String?) : null;
    final c = Get.find<JournalController>();
    final JournalEntry? entry = id == null ? null : c.entries.firstWhereOrNull((e) => e.id == id);

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
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: FreudColors.richBrown),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text('Journal', style: theme.textTheme.displaySmall),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: entry == null
                    ? Center(
                        child: Text('Entry not found', style: theme.textTheme.bodyLarge?.copyWith(color: FreudColors.richBrown)),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: _moodColor(entry.mood).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    entry.type == 'voice' ? Icons.mic : Icons.edit_note,
                                    color: _moodColor(entry.mood),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.type == 'voice' ? 'Voice Journal' : 'Text Journal',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: FreudColors.richBrown,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          _StatusChip(status: entry.status),
                                          const SizedBox(width: 10),
                                          Text(
                                            entry.date,
                                            style: theme.textTheme.bodySmall?.copyWith(color: FreudColors.richBrown.withValues(alpha: 0.7)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (entry.type == 'voice')
                              _VoiceDetail(durationSec: entry.durationSec ?? 0)
                            else
                              _TextDetail(content: entry.content ?? ''),
                          ],
                        ),
                      ),
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

class _TextDetail extends StatelessWidget {
  const _TextDetail({required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FreudColors.richBrown.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        content.isEmpty ? 'No content' : content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: FreudColors.richBrown),
      ),
    );
  }
}

class _VoiceDetail extends StatelessWidget {
  const _VoiceDetail({required this.durationSec});
  final int durationSec;
  @override
  Widget build(BuildContext context) {
    final mm = (durationSec ~/ 60).toString().padLeft(2, '0');
    final ss = (durationSec % 60).toString().padLeft(2, '0');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FreudColors.richBrown.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: FreudColors.richBrown.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: FreudColors.richBrown.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.play_arrow, color: FreudColors.richBrown),
          ),
          const SizedBox(width: 12),
          Text('Duration • $mm:$ss', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: FreudColors.richBrown)),
        ],
      ),
    );
  }
}
