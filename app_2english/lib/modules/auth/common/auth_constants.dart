import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Constants và cấu hình cho module Authentication
class AuthConstants {
  AuthConstants._();

  // Colors - Sử dụng từ AppColors global
  // Có thể giữ lại để reference, hoặc sử dụng trực tiếp AppColors
  @Deprecated('Sử dụng AppColors.primaryColor hoặc Theme.of(context).colorScheme.primary')
  static const Color brandColor = AppColors.primaryColor;
  
  @Deprecated('Sử dụng AppColors.fieldFill hoặc context.fieldFillColor')
  static const Color fieldFill = AppColors.fieldFill;
  
  @Deprecated('Sử dụng AppColors.borderColor hoặc context.borderColor')
  static const Color borderColor = AppColors.borderColor;

  // Spacing
  static const double cornerRadius = 16;
  static const double buttonCornerRadius = 12;
  static const double gapSmall = 8;
  static const double gap = 12;
  static const double gapLarge = 20;
  static const double gapXL = 28;

  // Messages
  static const String loginSuccess = 'Đăng nhập thành công!';
  static const String registerSuccess = 'Đăng ký thành công!';
  static const String loginFailed = 'Đăng nhập thất bại!';
  static const String registerFailed = 'Đăng ký thất bại!';
}

