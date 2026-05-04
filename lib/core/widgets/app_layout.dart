import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget? header;
  final Widget? searchBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool useSafeArea;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const AppLayout({
    super.key,
    this.header,
    this.searchBar,
    required this.body,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.useSafeArea = true,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        if (header != null) header!,
        if (searchBar != null) ...[
          const SizedBox(height: 10),
          searchBar!,
        ],
        Expanded(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: body,
          ),
        ),
      ],
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
    );
  }
}
