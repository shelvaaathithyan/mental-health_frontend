import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/assessment_controller.dart';
import '../../../core/theme.dart';
import '../../../onBoarding/customize_attributes_screen.dart';

class AssessmentFlowScreen extends StatefulWidget {
  const AssessmentFlowScreen({super.key});

  static const String routeName = '/assessment';

  @override
  State<AssessmentFlowScreen> createState() => _AssessmentFlowScreenState();
}

class _AssessmentFlowScreenState extends State<AssessmentFlowScreen> {
  static const int _totalSteps = 14;
  static const List<String> _stepTitles = [
    'Assessment',
    'Preferred address',
    'Just a quick check',
  ];
  final PageController _pageController = PageController();
  final AssessmentController _controller =
      Get.put(AssessmentController(), permanent: true);

  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_currentStep == 0) {
      Get.back<void>();
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleContinue() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      Get.to(
        () => const CustomizeAttributesScreen(saveDetails: false),
        transition: Transition.cupertino,
        duration: const Duration(milliseconds: 320),
      );
    }
  }

  bool _isContinueEnabled() {
    switch (_currentStep) {
      case 0:
        return _controller.hasGoal;
      case 1:
        return _controller.hasGender;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _AssessmentHeader(
              stepLabel: _stepTitles[_currentStep],
              currentStep: _currentStep + 1,
              totalSteps: _totalSteps,
              onBack: _handleBack,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() => _currentStep = value);
                },
                children: const [
                  _GoalSelectionStep(),
                  _GenderSelectionStep(),
                  _AgeSelectionStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Obx(
                () {
                  final enabled = _isContinueEnabled();
                  return _PrimaryButton(
                    label: _currentStep == 2 ? 'Continue' : 'Continue',
                    onPressed: enabled ? _handleContinue : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssessmentHeader extends StatelessWidget {
  const _AssessmentHeader({
    required this.stepLabel,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  final String stepLabel;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _CircularIconButton(onTap: onBack),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  stepLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: FreudColors.richBrown,
                  ),
                ),
              ],
            ),
          ),
          _ProgressPill(currentStep: currentStep, totalSteps: totalSteps),
        ],
      ),
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  const _CircularIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: FreudColors.richBrown.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: FreudColors.richBrown),
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: FreudColors.richBrown.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        '$currentStep of $totalSteps',
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: FreudColors.richBrown,
        ),
      ),
    );
  }
}

class _GoalSelectionStep extends StatelessWidget {
  const _GoalSelectionStep();

  static const List<_GoalOption> _options = [
    _GoalOption(
      id: 'reduce-stress',
      label: 'I wanna reduce stress',
      icon: Icons.favorite_outline,
    ),
    _GoalOption(
      id: 'ai-therapy',
      label: 'I wanna try AI Therapy',
      icon: Icons.psychology_alt_rounded,
    ),
    _GoalOption(
      id: 'cope-trauma',
      label: 'I want to cope with trauma',
      icon: Icons.spa_rounded,
    ),
    _GoalOption(
      id: 'better-person',
      label: 'I want to be a better person',
      icon: Icons.emoji_people_rounded,
    ),
    _GoalOption(
      id: 'just-trying',
      label: "Just trying out the app, mate!",
      icon: Icons.sentiment_satisfied_alt_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<AssessmentController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            "What's your health goal for today?",
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final option = _options[index];
                return Obx(
                  () {
                    final isSelected = controller.goalId.value == option.id;
                    return _GoalOptionTile(
                      option: option,
                      selected: isSelected,
                      onTap: () => controller.selectGoal(option.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalOption {
  const _GoalOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class _GoalOptionTile extends StatelessWidget {
  const _GoalOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _GoalOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = selected
        ? FreudColors.paleOlive.withValues(alpha: 0.65)
        : Colors.white;
    final borderColor = selected
        ? Colors.transparent
        : FreudColors.richBrown.withValues(alpha: 0.12);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: FreudColors.mossGreen.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: selected
                    ? FreudColors.richBrown.withValues(alpha: 0.1)
                    : FreudColors.cream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                option.icon,
                color: selected ? FreudColors.richBrown : FreudColors.richBrown,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: FreudColors.richBrown,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? FreudColors.richBrown
                      : FreudColors.richBrown.withValues(alpha: 0.3),
                  width: 2,
                ),
                color: selected ? FreudColors.richBrown : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderOption {
  const _GenderOption({
    required this.id,
    required this.label,
    required this.pronouns,
    required this.icon,
  });

  final String id;
  final String label;
  final String pronouns;
  final IconData icon;
}

class _GenderSelectionStep extends StatelessWidget {
  const _GenderSelectionStep();

  static const List<_GenderOption> _options = [
    _GenderOption(
      id: 'female',
      label: 'Female',
      pronouns: 'She / Her',
      icon: Icons.woman_rounded,
    ),
    _GenderOption(
      id: 'male',
      label: 'Male',
      pronouns: 'He / Him',
      icon: Icons.man_rounded,
    ),
    _GenderOption(
      id: 'non-binary',
      label: 'Non-binary',
      pronouns: 'They / Them',
      icon: Icons.diversity_3_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<AssessmentController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'How do you identify?',
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "I'll use this to address you respectfully during our chats.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FreudColors.richBrown.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final option = _options[index];
                return Obx(
                  () {
                    final isSelected = controller.genderId.value == option.id;
                    return _GenderOptionTile(
                      option: option,
                      selected: isSelected,
                      onTap: () => controller.selectGender(option.id),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: controller.skipGender,
              style: TextButton.styleFrom(
                foregroundColor: FreudColors.richBrown,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Prefer to skip'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _GenderOptionTile extends StatelessWidget {
  const _GenderOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _GenderOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = selected
        ? FreudColors.paleOlive.withValues(alpha: 0.65)
        : Colors.white;
    final borderColor = selected
        ? Colors.transparent
        : FreudColors.richBrown.withValues(alpha: 0.12);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: FreudColors.mossGreen.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: selected
                    ? FreudColors.richBrown.withValues(alpha: 0.1)
                    : FreudColors.cream,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(option.icon, color: FreudColors.richBrown),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: FreudColors.richBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.pronouns,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreudColors.richBrown.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? FreudColors.richBrown
                      : FreudColors.richBrown.withValues(alpha: 0.3),
                  width: 2,
                ),
                color: selected ? FreudColors.richBrown : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AgeSelectionStep extends StatefulWidget {
  const _AgeSelectionStep();

  @override
  State<_AgeSelectionStep> createState() => _AgeSelectionStepState();
}

class _AgeSelectionStepState extends State<_AgeSelectionStep> {
  static final List<int> _ages = List<int>.generate(73, (index) => index + 13);

  late final FixedExtentScrollController _scrollController;
  late final AssessmentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AssessmentController>();
    final currentAge = _controller.age.value;
    final initialIndex = _ages.indexOf(currentAge);
    _scrollController = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : (_ages.length ~/ 2),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'How old are you?',
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "This helps me tailor guidance that's right for you.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FreudColors.richBrown.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FreudColors.richBrown.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: FreudColors.richBrown.withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                      ),
                      GetX<AssessmentController>(
                        builder: (controller) {
                          final selectedAge = controller.age.value;
                          return ListWheelScrollView.useDelegate(
                          controller: _scrollController,
                          itemExtent: 64,
                          physics: const FixedExtentScrollPhysics(),
                          perspective: 0.002,
                          onSelectedItemChanged: (index) {
                            if (index >= 0 && index < _ages.length) {
                              controller.updateAge(_ages[index]);
                            }
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: _ages.length,
                            builder: (context, index) {
                              if (index < 0 || index >= _ages.length) {
                                return null;
                              }
                              final age = _ages[index];
                              final isSelected = selectedAge == age;
                              return AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 160),
                                style: theme.textTheme.displaySmall?.copyWith(
                                      fontSize: isSelected ? 46 : 28,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: FreudColors.richBrown.withValues(
                                        alpha: isSelected ? 1 : 0.35,
                                      ),
                                    ) ??
                                    TextStyle(
                                      fontSize: isSelected ? 46 : 28,
                                      fontWeight:
                                          isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: FreudColors.richBrown.withValues(
                                        alpha: isSelected ? 1 : 0.35,
                                      ),
                                    ),
                                child: Center(child: Text('$age')),
                              );
                            },
                          ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Text(
                    "I'm ${_controller.age.value} years old",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: FreudColors.richBrown,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor:
              onPressed != null ? FreudColors.richBrown : FreudColors.richBrown.withValues(alpha: 0.3),
          foregroundColor: FreudColors.textLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: FreudColors.textLight,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
