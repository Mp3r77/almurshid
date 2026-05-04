import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Widget? leadingIcon;
  final Color? backgroundColor;
  final bool showFilter;
  final VoidCallback? onFilterPressed;

  const AppSearchBar({
    super.key,
    this.hintText = 'أدخل كلمة البحث',
    this.onChanged,
    this.controller,
    this.leadingIcon,
    this.backgroundColor,
    this.showFilter = false,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor.withOpacity(0.08);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (showFilter) ...[
            GestureDetector(
              onTap: onFilterPressed,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor ?? colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: shadowColor, blurRadius: 10),
                  ],
                ),
                child: Icon(
                  Icons.tune,
                  color: backgroundColor != null
                      ? Colors.black87
                      : colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: backgroundColor ?? colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: backgroundColor == null
                    ? [BoxShadow(color: shadowColor, blurRadius: 10)]
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.right,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: GoogleFonts.cairo(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
