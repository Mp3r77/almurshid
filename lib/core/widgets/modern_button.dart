import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ModernButtonStyle {
  primary,
  secondary,
  outline,
  gradient,
}

class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonStyle style;
  final double? width;
  final double height;
  final IconData? icon;
  final bool isLoading;
  final double borderRadius;
  final List<Color>? gradientColors;
  final double elevation;

  const ModernButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = ModernButtonStyle.primary,
    this.width,
    this.height = 55,
    this.icon,
    this.isLoading = false,
    this.borderRadius = 20,
    this.gradientColors,
    this.elevation = 4,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: widget.style != ModernButtonStyle.outline
                    ? [
                        BoxShadow(
                          color: _getButtonColor().withOpacity(0.3),
                          blurRadius: widget.elevation * 2,
                          offset: Offset(0, widget.elevation),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _getGradient(),
                    color: _getSolidColor(),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: widget.style == ModernButtonStyle.outline
                        ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.style == ModernButtonStyle.outline
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.text,
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getTextColor(),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: _getTextColor(),
                                  size: 22,
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getButtonColor() {
    switch (widget.style) {
      case ModernButtonStyle.primary:
        return Theme.of(context).primaryColor;
      case ModernButtonStyle.secondary:
        return Theme.of(context).colorScheme.secondary;
      case ModernButtonStyle.outline:
        return Colors.transparent;
      case ModernButtonStyle.gradient:
        return Theme.of(context).primaryColor;
    }
  }

  LinearGradient? _getGradient() {
    if (widget.style == ModernButtonStyle.gradient) {
      return LinearGradient(
        colors: widget.gradientColors ??
            [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return null;
  }

  Color? _getSolidColor() {
    final colorScheme = Theme.of(context).colorScheme;
    if (widget.style == ModernButtonStyle.gradient) {
      return null;
    }
    switch (widget.style) {
      case ModernButtonStyle.primary:
        return colorScheme.primary;
      case ModernButtonStyle.secondary:
        return colorScheme.secondary;
      case ModernButtonStyle.outline:
        return colorScheme.surface;
      default:
        return colorScheme.primary;
    }
  }

  Color _getTextColor() {
    if (widget.style == ModernButtonStyle.outline) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.onPrimary;
  }
}
