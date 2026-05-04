import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final currentIndex = state.selectedIndex;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ModernNavBarItem(
                  icon: Icons.home_outlined,
                  label: l10n.home,
                  isSelected: currentIndex == 0,
                  onTap: () => context
                      .read<HomeBloc>()
                      .add(const ChangeBottomNavIndex(0)),
                ),
                _ModernNavBarItem(
                  icon: Icons.calendar_month_outlined,
                  label: l10n.appointments,
                  isSelected: currentIndex == 1,
                  onTap: () => context
                      .read<HomeBloc>()
                      .add(const ChangeBottomNavIndex(1)),
                ),
                _ModernNavBarItem(
                  icon: Icons.chat_bubble_outline_outlined,
                  label: l10n.messages,
                  isSelected: currentIndex == 2,
                  onTap: () => context
                      .read<HomeBloc>()
                      .add(const ChangeBottomNavIndex(2)),
                ),
                _ModernNavBarItem(
                  icon: Icons.person_outline_outlined,
                  label: l10n.profile,
                  isSelected: currentIndex == 3,
                  onTap: () => context
                      .read<HomeBloc>()
                      .add(const ChangeBottomNavIndex(3)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModernNavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernNavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ModernNavBarItem> createState() => _ModernNavBarItemState();
}

class _ModernNavBarItemState extends State<_ModernNavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_ModernNavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      widget.isSelected ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: widget.isSelected ? 48 : 40,
                  height: widget.isSelected ? 48 : 40,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? colorScheme.onPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.onPrimary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Transform.scale(
                    scale: widget.isSelected ? _iconScaleAnimation.value : 1.0,
                    child: Icon(
                      widget.icon,
                      color: widget.isSelected
                          ? colorScheme.primary
                          : colorScheme.onPrimary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: GoogleFonts.cairo(
                    color: widget.isSelected ? Colors.white : Colors.white70,
                    fontSize: widget.isSelected ? 11 : 10,
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  child: Text(widget.label),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
