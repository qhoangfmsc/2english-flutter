import 'package:flutter/material.dart';
import 'package:app_2english/modules/test/screens/clerk_test_screen.dart';

class TestHubScreen extends StatelessWidget {
  const TestHubScreen({super.key});

  // ========== Build Methods ==========
  @override
  Widget build(BuildContext context) {
    final List<_TestItem> tests = [
      _TestItem(
        title: 'Clerk Test',
        description: 'Auth UI with Google sign-in; shows user name after login',
        builder: (context) => const ClerkTestScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Hub'),
      ),
      body: ListView.separated(
        itemCount: tests.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = tests[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item.builder(context)),
              );
            },
          );
        },
      ),
    );
  }
}

class _TestItem {
  const _TestItem({
    required this.title,
    required this.description,
    required this.builder,
  });
  final String title;
  final String description;
  final WidgetBuilder builder;
}


