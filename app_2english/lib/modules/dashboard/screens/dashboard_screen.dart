import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import '../../../core/widgets/main_layout.dart';
import '../../vocab/screens/vocab_screen.dart';
import '../../account/screens/account_screen.dart';
import '../../auth/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Widget _dashboardContent() {
    return const Center(child: Text('Dashboard'));
  }

  Widget _currentBody() {
    switch (_currentIndex) {
      case 0:
        return _dashboardContent();
      case 1:
        return const VocabScreen();
      case 2:
        return const AccountScreen();
      default:
        return _dashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClerkAuthBuilder(
      signedInBuilder: (context, authState) {
        return MainLayout(
          currentBottomNavIndex: _currentIndex,
          onBottomNavTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          body: _currentBody(),
        );
      },
      signedOutBuilder: (context, authState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
