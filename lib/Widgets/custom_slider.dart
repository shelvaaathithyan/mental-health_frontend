import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart' show FeedbackType;

import '../Services/haptic_service.dart';
import '../core/theme.dart';

class CustomSlider extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  final double defaultValue;
  final Function(double) onChanged;

  const CustomSlider(
      {super.key,
      required this.leadingText,
      required this.trailingText,
      required this.defaultValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accent = FreudColors.mossGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leadingText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: FreudColors.richBrown,
                ),
              ),
              Text(
                trailingText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: FreudColors.richBrown.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: accent,
              inactiveTrackColor: accent.withValues(alpha: 0.25),
              thumbColor: FreudColors.richBrown,
            ),
            child: Slider(
              value: defaultValue,
              onChanged: (value) {
                HapticService.feedback(FeedbackType.light);
                onChanged(value);
              },
              min: 0,
              max: 5,
              divisions: 5,
              label: defaultValue.round().toString(),
            ),
          ),
        ],
      ),
    );
  }
}
