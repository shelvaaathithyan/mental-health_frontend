import 'package:ai_therapy/Widgets/custom_slider.dart';
import 'package:ai_therapy/View/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/user_controller.dart';
import '../core/theme.dart';

class CustomizeAttributesScreen extends StatelessWidget {
  final bool saveDetails;
  const CustomizeAttributesScreen({super.key, required this.saveDetails});

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());

    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());
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
                    onPressed: () => Get.back<void>(),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: FreudColors.richBrown.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Text(
                      saveDetails ? 'Preferences' : 'Onboarding',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: FreudColors.richBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's tailor Emma to you",
                      style: textTheme.displayMedium?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      saveDetails
                          ? 'Fine-tune how sessions feel so they stay aligned with your current needs.'
                          : "Adjust Emma's tone and approach so our sessions match what you're looking for.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: FreudColors.textDark.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: FreudColors.richBrown.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: FreudColors.richBrown.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Session vibe',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: FreudColors.richBrown,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Drag each slider to set how you’d like me to show up.',
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 32),
                          Obx(
                            () => CustomSlider(
                              leadingText: 'Empathy',
                              trailingText: 'Understanding',
                              defaultValue:
                                  userController.empUnd.value.toDouble(),
                              onChanged: (value) {
                                userController.empUnd.value = value.round();
                              },
                            ),
                          ),
                          Obx(
                            () => CustomSlider(
                              leadingText: 'Listening',
                              trailingText: 'Solutioning',
                              defaultValue:
                                  userController.lisSol.value.toDouble(),
                              onChanged: (value) {
                                userController.lisSol.value = value.round();
                              },
                            ),
                          ),
                          Obx(
                            () => CustomSlider(
                              leadingText: 'Holistic',
                              trailingText: 'Targeted',
                              defaultValue:
                                  userController.hoTa.value.toDouble(),
                              onChanged: (value) {
                                userController.hoTa.value = value.round();
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 16),
                              decoration: BoxDecoration(
                                color: FreudColors.paleOlive
                                    .withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your current mix',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: FreudColors.richBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${userController.empUnd.value}/5 Empathy, '
                                    '${userController.lisSol.value}/5 Listening, '
                                    '${userController.hoTa.value}/5 Holistic',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: FreudColors.richBrown
                                          .withValues(alpha: 0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (saveDetails) {
                      Get.back<void>();
                    } else {
                      Get.offAll(() => const HomeView());
                    }
                  },
                  child: Text(saveDetails ? 'Save changes' : 'Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
