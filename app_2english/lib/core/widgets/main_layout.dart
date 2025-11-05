import 'package:flutter/material.dart';
import 'package:app_2english/core/widgets/app_header.dart';
import 'package:app_2english/core/widgets/app_bottom_nav.dart';

/// Main layout wrapper that includes header and bottom navigation
/// This provides a consistent layout across all modules that need it
class MainLayout extends StatelessWidget {

  const MainLayout({
    super.key,
    required this.body,
    this.currentBottomNavIndex = 0,
    this.onBottomNavTap,
  });
  final Widget body;
  final int currentBottomNavIndex;
  final Function(int)? onBottomNavTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(child: body),
            if (onBottomNavTap != null)
              AppBottomNav(
                currentIndex: currentBottomNavIndex,
                onTap: onBottomNavTap!,
              ),
          ],
        ),
      ),
    );
  }
}

