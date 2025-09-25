import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_therapy/core/theme.dart';
import 'package:ai_therapy/screens/auth/signup/signup_screen.dart';
import 'package:ai_therapy/screens/auth/widgets/auth_components.dart';
import 'package:ai_therapy/screens/onboarding/assessment/assessment_flow_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);

    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.topCenter,
            child: AuthFlowerBadge(size: 58),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(44),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 35,
                  spreadRadius: 0,
                  offset: const Offset(0, 24),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Sign In To Neptune.ai',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: FreudColors.richBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'We\'re glad you\'re back. Let\'s continue the journey.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FreudColors.textDark.withValues(alpha: 0.55),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                AuthInputField(
                  label: 'Email Address',
                  hintText: 'princesskaguya@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  borderColor: const Color(0xFF8FB561),
                  focusedBorderColor: const Color(0xFF8FB561),
                ),
                const SizedBox(height: 24),
                AuthInputField(
                  label: 'Password',
                  hintText: 'Enter your password...',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  borderColor: FreudColors.textDark.withValues(alpha: 0.08),
                  focusedBorderColor: FreudColors.richBrown,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FreudColors.richBrown,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: Text(
                    'Or continue with',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FreudColors.textDark.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialChip(icon: Icons.facebook_rounded),
                    SizedBox(width: 18),
                    _SocialChip(icon: Icons.g_mobiledata_rounded),
                    SizedBox(width: 18),
                    _SocialChip(icon: Icons.camera_alt_outlined),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FreudColors.textDark.withValues(alpha: 0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: Text(
                        'Sign Up',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FreudColors.cocoa,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset flow coming soon!'),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FreudColors.cocoa,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _handleSignIn() {
    FocusScope.of(context).unfocus();
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
  Get.offAllNamed(AssessmentFlowScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Color(0xFFF47C2A),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _SocialChip extends StatelessWidget {
  const _SocialChip({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF2EBE3),
        border: Border.all(
          color: FreudColors.textDark.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: FreudColors.richBrown,
        size: 26,
      ),
    );
  }
}
