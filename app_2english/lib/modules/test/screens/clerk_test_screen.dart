import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

class ClerkTestScreen extends StatelessWidget {
  const ClerkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clerk Test'),
      ),
      body: SafeArea(
        child: ClerkErrorListener(
          child: ClerkAuthBuilder(
            signedInBuilder: (context, authState) {
              final user = authState.user;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Hello, ${user?.firstName ?? 'User'}'),
                    const SizedBox(height: 12),
                    const ClerkUserButton(),
                  ],
                ),
              );
            },
            signedOutBuilder: (context, authState) {
              // Built-in Clerk UI. Enable Google in Clerk Dashboard to show the provider.
              return const Center(
                child: ClerkAuthentication(),
              );
            },
          ),
        ),
      ),
    );
  }
}


