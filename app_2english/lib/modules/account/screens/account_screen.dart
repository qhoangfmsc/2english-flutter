import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:app_2english/modules/auth/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClerkAuthBuilder(
                      signedInBuilder: (context, authState) {
                        final imageUrl = authState.user?.imageUrl ?? '';
                        final firstName = authState.user?.firstName ?? '';
                        final lastName = authState.user?.lastName ?? '';
                        final fullName = '$firstName $lastName';
                        final email = authState.user?.email ?? '';

                        debugPrint(imageUrl);

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
                                  return Image(
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email,
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
                      signedOutBuilder: (context, authState) {
                        return Text('Signed out');
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
                        offset: Offset(0, 10),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      spacing: 12,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Preferences',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ClerkAuthBuilder(
                              signedInBuilder: (context, authState) {
                                return InkWell(
                                  onTap: () async {
                                    try {
                                      await authState.signOut();
                                    } catch (e) {
                                      debugPrint('Sign out error: $e');
                                    } finally {
                                      if (context.mounted) {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          (route) => false,
                                        );
                                      }
                                    }
                                  },
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      Icon(Icons.logout, color: Colors.red),
                                      Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                                    ],
                                  ),
                                );
                              },
                              signedOutBuilder: (context, _) {
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
