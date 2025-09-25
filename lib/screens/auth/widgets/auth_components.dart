import 'package:flutter/material.dart';
import 'package:ai_therapy/core/theme.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    this.headerHeight = 260,
  });

  final Widget child;
  final EdgeInsets padding;
  final double headerHeight;

  static const Color _backgroundColor = Color(0xFF5A5148);
  static const Color _headerColor = Color(0xFFA5B76A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: _backgroundColor),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: headerHeight,
              decoration: const BoxDecoration(
                color: _headerColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(96),
                  bottomRight: Radius.circular(96),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: padding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      padding.vertical -
                      MediaQuery.of(context).padding.vertical,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFlowerBadge extends StatelessWidget {
  const AuthFlowerBadge({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _petal(const Offset(0, -16)),
          _petal(const Offset(0, 16)),
          _petal(const Offset(-16, 0)),
          _petal(const Offset(16, 0)),
          Container(
            width: size * 0.22,
            height: size * 0.22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AuthScaffold._headerColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _petal(Offset offset) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: size * 0.42,
        height: size * 0.42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.suffixIcon,
    this.onSuffixTap,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor = const Color(0xFFF7F2EC),
    this.textInputAction,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color fillColor;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: FreudColors.textDark,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          obscureText: obscureText,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon,
              color: FreudColors.textDark.withValues(alpha: 0.4),
            ),
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(
                      suffixIcon,
                      color: FreudColors.textDark.withValues(alpha: 0.4),
                    ),
                  )
                : null,
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: borderColor ?? Colors.transparent,
                width: 1.4,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: focusedBorderColor ?? FreudColors.richBrown,
                width: 1.6,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          ),
        ),
      ],
    );
  }
}
