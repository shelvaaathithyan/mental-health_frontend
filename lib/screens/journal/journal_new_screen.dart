import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'journal_voice_screen.dart';
import 'journal_text_screen.dart';

class JournalNewScreen extends StatelessWidget {
  static const routeName = '/journal/new';
  const JournalNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Column(
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
                  Text('New Mental Health Journal',
                      style: theme.textTheme.displaySmall),
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    _JournalTypeCard(
                      icon: Icons.mic,
                      title: 'Voice Journal',
                      subtitle:
                          'Automatically create health journal by Voice & Face detection with AI',
                      onTap: () => Navigator.of(context)
                          .pushNamed(JournalVoiceScreen.routeName),
                    ),
                    const SizedBox(height: 16),
                    _JournalTypeCard(
                      icon: Icons.edit_note,
                      title: 'Text Journal',
                      subtitle:
                          'Set up manual text journal based on your current mood & conditions',
                      onTap: () => Navigator.of(context)
                          .pushNamed(JournalTextScreen.routeName),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Default to Text Journal for quick start
                          Navigator.of(context)
                              .pushNamed(JournalTextScreen.routeName);
                        },
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

class _JournalTypeCard extends StatelessWidget {
  const _JournalTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: FreudColors.richBrown.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: FreudColors.richBrown.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
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
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: FreudColors.richBrown),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: FreudColors.richBrown.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: FreudColors.richBrown),
        ],
        ),
      ),
    );
  }
}
