import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool hasBadge;
  final Color? iconColor;
  final Color? borderColor;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.hasBadge = false,
    this.iconColor = Colors.white,
    this.borderColor = Colors.white24,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor =
        iconColor ?? Theme.of(context).colorScheme.onPrimary;
    final resolvedBorderColor = borderColor ??
        Theme.of(context).colorScheme.onPrimary.withOpacity(0.24);

    return Stack(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: resolvedBorderColor, width: 1),
          ),
          child: IconButton(
            icon: Icon(icon, color: resolvedIconColor, size: 24),
            onPressed: onPressed,
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
