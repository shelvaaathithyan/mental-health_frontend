import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class FreudBottomNavItem {
  const FreudBottomNavItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class FreudBottomNavbar extends StatelessWidget {
  const FreudBottomNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    required this.onCenterTap,
  }) : assert(items.length == 4, 'Freud nav expects exactly 4 items.');

  final List<FreudBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onCenterTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            top: 24,
            child: CustomPaint(
              painter: _FreudNavPainter(),
            ),
          ),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: onCenterTap,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: FreudColors.mossGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: FreudColors.mossGreen.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: FreudColors.textLight,
                  size: 28,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (offset) {
                        final index = offset;
                        return _FreudNavTile(
                          item: items[index],
                          isSelected: index == currentIndex,
                          onTap: () => onItemSelected(index),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (offset) {
                        final index = offset + 2;
                        return _FreudNavTile(
                          item: items[index],
                          isSelected: index == currentIndex,
                          onTap: () => onItemSelected(index),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreudNavTile extends StatelessWidget {
  const _FreudNavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final FreudBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        isSelected ? FreudColors.mossGreen : FreudColors.richBrown.withValues(alpha: 0.45);
    final Color labelColor =
        isSelected ? FreudColors.mossGreen : FreudColors.richBrown.withValues(alpha: 0.55);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: iconColor, size: 22),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: labelColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 10,
                      height: 1.0,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isSelected ? 1 : 0,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: FreudColors.mossGreen,
                    shape: BoxShape.circle,
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

class _FreudNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final path = Path();
    final width = size.width;
    final height = size.height;
    final midX = width / 2;
    const notchRadius = 44.0;
    const controlOffset = 36.0;

    path.moveTo(24, 0);
    path.quadraticBezierTo(0, 0, 0, 24);
    path.lineTo(0, height - 24);
    path.quadraticBezierTo(0, height, 24, height);
    path.lineTo(width - 24, height);
    path.quadraticBezierTo(width, height, width, height - 24);
    path.lineTo(width, 24);
    path.quadraticBezierTo(width, 0, width - 24, 0);

    path.lineTo(midX + notchRadius + controlOffset, 0);
    path.quadraticBezierTo(
      midX + notchRadius,
      0,
      midX + notchRadius * 0.85,
      12,
    );
    path.cubicTo(
      midX + notchRadius * 0.65,
      34,
      midX + notchRadius * 0.2,
      60,
      midX,
      60,
    );
    path.cubicTo(
      midX - notchRadius * 0.2,
      60,
      midX - notchRadius * 0.65,
      34,
      midX - notchRadius * 0.85,
      12,
    );
    path.quadraticBezierTo(
      midX - notchRadius,
      0,
      midX - notchRadius - controlOffset,
      0,
    );
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.15), 12, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
