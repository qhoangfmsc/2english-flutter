import 'package:flutter/material.dart';

/// Widget hiển thị badge với viền và nền màu xanh
class OnboardingBadge extends StatelessWidget {

  const OnboardingBadge({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE6FFF5),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF10B981), width: 1.2),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF10B981),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

