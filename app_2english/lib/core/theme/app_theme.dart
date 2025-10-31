import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App Theme Configuration
/// 
/// Theme trong Flutter tương tự như CSS variables:
/// - ThemeData là nơi chứa tất cả styling
/// - Truy cập qua `Theme.of(context)`
/// - Hỗ trợ light/dark mode tự động
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // ColorScheme - màu sắc chính của app
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.light,
      ),

      // Mở rộng với custom colors (giống CSS variables)
      extensions: <ThemeExtension<dynamic>>[
        AppColorScheme(
          fieldFill: AppColors.fieldFill,
          borderColor: AppColors.borderColor,
        ),
      ],

      // InputDecorationTheme - styling cho text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // ElevatedButtonTheme - styling cho buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Có thể thêm dark theme sau
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      // ... thêm dark theme config
    );
  }
}

/// Custom Color Scheme Extension
/// Cho phép thêm custom colors vào Theme (không có trong ColorScheme mặc định)
/// 
/// Cách sử dụng:
/// ```dart
/// final colors = Theme.of(context).extension<AppColorScheme>();
/// colors?.fieldFill
/// ```
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.fieldFill,
    required this.borderColor,
  });

  final Color fieldFill;
  final Color borderColor;

  @override
  AppColorScheme copyWith({
    Color? fieldFill,
    Color? borderColor,
  }) {
    return AppColorScheme(
      fieldFill: fieldFill ?? this.fieldFill,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) {
      return this;
    }
    return AppColorScheme(
      fieldFill: Color.lerp(fieldFill, other.fieldFill, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}

/// Extension để truy cập custom colors dễ dàng hơn
extension AppThemeExtension on BuildContext {
  /// Lấy custom color scheme
  AppColorScheme? get appColors => Theme.of(this).extension<AppColorScheme>();

  /// Lấy field fill color
  Color get fieldFillColor => appColors?.fieldFill ?? AppColors.fieldFill;

  /// Lấy border color
  Color get borderColor => appColors?.borderColor ?? AppColors.borderColor;
}

