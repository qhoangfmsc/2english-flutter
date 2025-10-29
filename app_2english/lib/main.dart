import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'modules/splash/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2English',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Uncomment khi cần dark mode
      // themeMode: ThemeMode.system, // Tự động theo system
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
