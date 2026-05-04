import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? center;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const AppHeader({
    super.key,
    this.leading,
    this.trailing,
    this.center,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null) leading!,
          const SizedBox(width: 10),
          if (center != null) Expanded(child: center!),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
