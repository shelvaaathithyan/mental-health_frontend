import 'package:flutter/material.dart';
import '../../core/theme.dart';

class JournalStatsScreen extends StatefulWidget {
  static const routeName = '/journal/stats';
  const JournalStatsScreen({super.key});

  @override
  State<JournalStatsScreen> createState() => _JournalStatsScreenState();
}

class _JournalStatsScreenState extends State<JournalStatsScreen> {
  @override
  void initState() {
    super.initState();
    // Show demo crisis alert after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const _CrisisAlertDialog(),
      );
    });
  }

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
                  Text('Journal Stats', style: theme.textTheme.displaySmall),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Journal Stats for Feb 2025',
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 18),
                    const Expanded(child: _Bars()),
                    const SizedBox(height: 18),
                    const Row(
                      children: <Widget>[
                        _Pill(value: 81, label: 'Skipped', color: FreudColors.richBrown),
                        Spacer(),
                        Icon(Icons.emoji_emotions_outlined, color: FreudColors.sunshine),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Bars extends StatelessWidget {
  const _Bars();
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _Bar(value: 32, label: 'Negative', color: FreudColors.burntOrange),
        SizedBox(width: 24),
        _Bar(value: 44, label: 'Positive', color: FreudColors.mossGreen),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.label, required this.color});
  final int value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final height = (value.toDouble() / 50.0) * 220.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 88,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(36),
          ),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text('$value',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    )),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.value, required this.label, required this.color});
  final int value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$value',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(width: 8),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  )),
        ],
      ),
    );
  }
}

class _CrisisAlertDialog extends StatelessWidget {
  const _CrisisAlertDialog();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 140,
                color: FreudColors.paleOlive.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: const Icon(Icons.psychology_alt,
                    size: 64, color: FreudColors.richBrown),
              ),
            ),
            const SizedBox(height: 16),
            Text('Suicidal Mental Pattern Detected by AI!',
                style: theme.textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              'Our AI detected multiple occasions where you mentioned suicide in your journal. Crisis support is now active.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: FreudColors.sunshine.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: FreudColors.richBrown.withValues(alpha: 0.18)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.health_and_safety,
                      color: FreudColors.richBrown),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Crisis Support Now Active.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: FreudColors.richBrown,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: const Text('Call For Help!'),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
