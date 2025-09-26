import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/auth_controller.dart';
import '../../core/theme.dart';
import '../auth/signup/signup_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();

    Future<void> handleSignOut() async {
      try {
        await authController.logout();
        Get.offAllNamed(SignUpScreen.routeName);
      } catch (error) {
        Get.snackbar(
          'Sign out failed',
          error.toString(),
          backgroundColor: FreudColors.burntOrange,
          colorText: Colors.white,
        );
      }
    }

    return Scaffold(
      backgroundColor: FreudColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          FreudColors.burntOrange.withValues(alpha: 0.12),
                      child: const Icon(Icons.person,
                          color: FreudColors.burntOrange, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() {
                        final user = authController.currentUser.value;
                        final displayName = user?.displayName ?? 'Guest';
                        final email = user?.email ?? 'guest@example.com';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName.isEmpty ? 'Hey there' : displayName,
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.mail_outline_rounded,
                                    size: 16, color: FreudColors.mossGreen),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    email,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: FreudColors.richBrown
                                          .withValues(alpha: 0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _ProfileTile(
                  icon: Icons.lock_outline,
                  label: 'Privacy & Security',
                  onTap: () {}),
              const SizedBox(height: 10),
              _ProfileTile(
                  icon: Icons.palette_outlined,
                  label: 'Appearance',
                  onTap: () {}),
              const SizedBox(height: 10),
              _ProfileTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () {}),
              const SizedBox(height: 10),
              _ProfileTile(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {}),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.logout,
                label: 'Sign Out',
                destructive: true,
                onTap: handleSignOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Colors.redAccent : FreudColors.richBrown;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child:
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.chevron_right,
                color: FreudColors.richBrown, size: 18),
          ],
        ),
      ),
    );
  }
}
