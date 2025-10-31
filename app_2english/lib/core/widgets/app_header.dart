import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import '../theme/app_colors.dart';

/// Reusable navigation bar with logo, user info, and dropdown menu
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Image(
          image: AssetImage('assets/logo/zobite-avatar.png'),
          width: 20,
          height: 20,
        ),
      ),
      title: const Spacer(),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClerkAuthBuilder(
            signedInBuilder: (context, authState) {
              final user = authState.user;
              final fullName =
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
              return Center(
                child: Text(
                  fullName.isEmpty ? 'Xin chào' : 'Xin chào, $fullName',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            },
            signedOutBuilder: (context, authState) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
