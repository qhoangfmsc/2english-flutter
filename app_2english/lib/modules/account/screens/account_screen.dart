import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_2english/core/theme/app_colors.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:app_2english/modules/auth/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // ========== Auth Sheet Logic ==========
  Future<void> _showOAuthSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return ClerkAuthBuilder(
          signedInBuilder: (ctx, authState) {
            // Close the sheet once signed in
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(sheetContext).canPop()) {
                Navigator.of(sheetContext).pop();
              }
            });
            return const SizedBox.shrink();
          },
          signedOutBuilder: (ctx, authState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.35,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: const ClerkAuthentication(),
            );
          },
        );
      },
    );
  }

  // ========== Build Methods ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClerkAuthBuilder(
                      signedInBuilder: (context, authState) {
                        final imageUrl = authState.user?.imageUrl ?? '';
                        final firstName = authState.user?.firstName ?? '';
                        final lastName = authState.user?.lastName ?? '';
                        final fullName = '$firstName $lastName';
                        final email = authState.user?.email ?? '';

                        return Row(
                          spacing: 12,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: Image(
                                image: NetworkImage(imageUrl),
                                width: 48,
                                height: 48,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Image(
                                    image: AssetImage('assets/images/user.png'),
                                    width: 48,
                                    height: 48,
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      signedOutBuilder: (context, authState) {
                        return Row(
                          spacing: 12,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: const Image(
                                image: AssetImage('assets/images/user.png'),
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Người dùng',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Đăng nhập để lưu dữ liệu học tập',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClerkAuthBuilder(
                    signedInBuilder: (context, authState) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          spacing: 12,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    try {
                                      await authState.signOut();
                                    } catch (e) {
                                      debugPrint('Sign out error: $e');
                                    } finally {
                                      if (context.mounted) {
                                        Navigator.of(
                                          context,
                                        ).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (_) => const LoginScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    }
                                  },
                                  child: const Row(
                                    spacing: 12,
                                    children: [
                                      Icon(Icons.logout, color: Colors.red),
                                      Text(
                                        'Đăng xuất',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    signedOutBuilder: (context, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          onPressed: () async {
                            await _showOAuthSheet(context);
                            // After closing, the surrounding ClerkAuthBuilder will rebuild
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Đăng nhập ngay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
