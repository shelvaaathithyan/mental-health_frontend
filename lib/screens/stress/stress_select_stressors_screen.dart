import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/stress_controller.dart';
import '../../core/theme.dart';

class SelectStressorsScreen extends StatelessWidget {
  static const String routeName = '/stress/select-stressors';
  const SelectStressorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<StressController>();

    return Scaffold(
      backgroundColor: FreudColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Stressors',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 8),
              Text(
                'Our AI will decide how your stressor will impacts your life in general.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Stack(
                  children: [
                    // Pale background orbs to fill negative space
                    const Positioned(
                      left: -40,
                      top: 48,
                      child: _Orb(size: 120, alpha: 0.12),
                    ),
                    const Positioned(
                      right: -32,
                      top: 20,
                      child: _Orb(size: 96, alpha: 0.12),
                    ),
                    const Positioned(
                      left: -28,
                      bottom: 36,
                      child: _Orb(size: 100, alpha: 0.12),
                    ),
                    const Positioned(
                      right: -36,
                      bottom: 12,
                      child: _Orb(size: 120, alpha: 0.12),
                    ),
                    // Bubbles layout
                    Align(
                      alignment: Alignment.center,
                      child: Obx(() => _Bubble(
                            label: controller.selectedStressor.value,
                            isPrimary: true,
                            onTap: () {},
                          )),
                    ),
                    Align(
                      alignment: const Alignment(-0.85, -0.3),
                      child: _Bubble(
                        label: 'Work',
                        onTap: () => controller.selectStressor('Work'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.9, -0.25),
                      child: _Bubble(
                        label: 'Life',
                        onTap: () => controller.selectStressor('Life'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.95, 0.4),
                      child: _Bubble(
                        label: 'Kids',
                        onTap: () => controller.selectStressor('Kids'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.95, 0.35),
                      child: _Bubble(
                        label: 'Other',
                        onTap: () => controller.selectStressor('Other'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.25, -0.7),
                      child: _Bubble(
                        label: 'Relationship',
                        onTap: () => controller.selectStressor('Relationship'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.25, -0.7),
                      child: _Bubble(
                        label: 'Finance',
                        onTap: () => controller.selectStressor('Finance'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0.72),
                      child: _Bubble(
                        label: 'Health',
                        onTap: () => controller.selectStressor('Health'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.6, 0.7),
                      child: _Bubble(
                        label: 'Study',
                        onTap: () => controller.selectStressor('Study'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.6, 0.68),
                      child: _Bubble(
                        label: 'Traffic',
                        onTap: () => controller.selectStressor('Traffic'),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => _ImpactPill(value: controller.impactLabel)),
              const SizedBox(height: 12),
              // Auto/Manual toggle for Life Impact
              Obx(() {
                final isAuto = controller.manualImpact.value == null;
                return Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Auto (AI)'),
                      selected: isAuto,
                      onSelected: (_) => controller.setManualImpact(null),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Manual'),
                      selected: !isAuto,
                      onSelected: (_) {
                        if (controller.manualImpact.value == null) {
                          controller.setManualImpact(3); // default to Moderate
                        }
                      },
                    ),
                    const Spacer(),
                    if (!isAuto)
                      TextButton(
                        onPressed: controller.clearManualImpact,
                        child: const Text('Reset'),
                      )
                  ],
                );
              }),
              const SizedBox(height: 10),
              // Manual impact level chips (shown only when Manual is selected)
              Obx(() {
                final manual = controller.manualImpact.value;
                if (manual == null) return const SizedBox.shrink();
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(5, (i) {
                    final level = i + 1;
                    final selected = level == manual;
                    return ChoiceChip(
                      label: Text(controller.impactLabelFor(level)),
                      selected: selected,
                      onSelected: (_) => controller.setManualImpact(level),
                    );
                  }),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/stress/overview'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
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

class _Bubble extends StatelessWidget {
  const _Bubble({required this.label, required this.onTap, this.isPrimary = false});

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final color = isPrimary ? FreudColors.mossGreen : FreudColors.textDark.withValues(alpha: 0.12);
    final textColor = isPrimary ? Colors.white : FreudColors.textDark.withValues(alpha: 0.8);
    final size = isPrimary ? 168.0 : 84.0;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isPrimary ? color : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: color, width: 1.2),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class _ImpactPill extends StatelessWidget {
  const _ImpactPill({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: FreudColors.burntOrange.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: FreudColors.burntOrange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Life Impact: $value',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, this.alpha = 0.1});
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FreudColors.textDark.withValues(alpha: alpha),
        shape: BoxShape.circle,
      ),
    );
  }
}
