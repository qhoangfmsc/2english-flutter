import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:app_2english/core/theme/app_colors.dart';
import 'package:app_2english/modules/test/screens/test_hub_screen.dart';
import 'package:app_2english/modules/dashboard/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ========== State Variables ==========
  int _tapCount = 0;
  DateTime? _lastTapAt;
  bool _isLoading = false;

  // ========== Navigation & Secret Gesture Logic ==========
  void _handleSecretTap() {
    final now = DateTime.now();
    if (_lastTapAt == null ||
        now.difference(_lastTapAt!).inMilliseconds > 2000) {
      _tapCount = 0;
    }
    _lastTapAt = now;
    _tapCount += 1;

    if (_tapCount >= 13) {
      _tapCount = 0;
      _lastTapAt = null;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TestHubScreen()),
      );
    }
  }

  // ========== Auth Actions ==========
  Future<void> _signInWithProvider(ClerkAuthState authState) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (mounted) {
        await _showOAuthDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng nhập: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showOAuthDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: const ClerkAuthentication(),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Build Methods ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 121, 204, 147),
              Color.fromARGB(255, 72, 155, 107),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ClerkAuthBuilder(
              signedInBuilder: (context, authState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                    (route) => false,
                  );
                });

                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              },
              signedOutBuilder: (context, authState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: _handleSecretTap,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Welcome to 2English',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Học tiếng Anh thật dễ dàng và hiệu quả',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 56,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const OnboardingScreen(),
                    //         ),
                    //       );
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //                       backgroundColor: Colors.white.withOpacity(0.2),
                    // foregroundColor: Colors.white,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    //   side: const BorderSide(
                    //     color: Colors.white,
                    //     width: 2,
                    //   ),
                    // ),
                    // elevation: 0,
                    //     ),
                    //     child: const Text(
                    //       'Bắt đầu',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _signInWithProvider(authState),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
