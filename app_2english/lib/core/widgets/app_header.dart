import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable navigation bar with logo, user info, and dropdown menu
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      toolbarHeight: 64, // make header a bit taller
      leadingWidth: 100, // give the logo more horizontal space
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: SvgPicture.asset(
          'assets/logo/zobite-icon-with-text-green.svg',
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, size: 22),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
