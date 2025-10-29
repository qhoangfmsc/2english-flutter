import 'package:flutter/material.dart';

/// App Colors - Quản lý tất cả màu sắc của ứng dụng (tương tự CSS variables)
/// 
/// Cách sử dụng:
/// - Trực tiếp: `AppColors.primaryColor`
/// - Qua Theme (khuyến nghị): `Theme.of(context).colorScheme.primary`
/// - Custom colors qua extension: `Theme.of(context).extension<AppColorScheme>()?.fieldFill`
class AppColors {
  AppColors._();

  // Primary Color
  static const Color primaryColor = Color(0xFF489B6B);

  // Form Colors
  static const Color fieldFill = Color(0xFFF5F6FA);
  static const Color borderColor = Color(0xFFE5E7EB);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF9FAFB);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}

