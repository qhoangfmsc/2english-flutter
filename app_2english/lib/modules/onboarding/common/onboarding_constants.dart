/// Constants và dữ liệu cấu hình cho quá trình onboarding
class OnboardingConstants {
  OnboardingConstants._();

  /// Danh sách các ngôn ngữ có thể chọn
  static const List<LanguageOption> languages = [
    LanguageOption(emoji: '🇪🇸', label: 'Tiếng Tây Ban Nha', value: 'Tiếng Tây Ban Nha'),
    LanguageOption(emoji: '🇫🇷', label: 'Tiếng Pháp', value: 'Tiếng Pháp'),
    LanguageOption(emoji: '🇯🇵', label: 'Tiếng Nhật', value: 'Tiếng Nhật'),
    LanguageOption(emoji: '🇬🇧', label: 'Tiếng Anh', value: 'Tiếng Anh'),
    LanguageOption(emoji: '🇰🇷', label: 'Tiếng Hàn', value: 'Tiếng Hàn'),
    LanguageOption(emoji: '🇹🇼', label: 'Tiếng Trung (Phồn thể)', value: 'Tiếng Trung (Phồn thể)'),
    LanguageOption(emoji: '🇨🇳', label: 'Tiếng Trung (Giản thể)', value: 'Tiếng Trung (Giản thể)'),
    LanguageOption(emoji: '🇻🇳', label: 'Tiếng Việt', value: 'Tiếng Việt'),
  ];

  /// Danh sách các chủ đề quan tâm
  static const List<String> topics = [
    'Giáo dục',
    'Lối sống',
    'Sức khỏe',
    'Khoa học',
    'Tiền điện tử',
    'Thể thao',
    'Không gian',
    'Chứng khoán',
    'Thể dục',
    'Kinh doanh',
    'Ẩm thực',
    'Thời tiết',
    'Máy tính',
    'Khác',
  ];

  /// Danh sách các lý do học tiếng Anh
  static const List<String> reasons = [
    'Rèn luyện trí não',
    'Du lịch',
    'Công việc',
    'Khác',
  ];

  /// Danh sách các trình độ tiếng Anh theo chuẩn CEFR
  static const List<LanguageLevel> languageLevels = [
    LanguageLevel(id: 'a1', title: 'A1 - Sơ cấp', subtitle: 'Người mới bắt đầu', badge: 'A1'),
    LanguageLevel(id: 'a2', title: 'A2 - Cơ bản', subtitle: 'Trình độ cơ bản', badge: 'A2'),
    LanguageLevel(id: 'b1', title: 'B1 - Trung cấp', subtitle: 'Trình độ trung bình', badge: 'B1'),
    LanguageLevel(id: 'b2', title: 'B2 - Trung cao cấp', subtitle: 'Trình độ khá', badge: 'B2'),
    LanguageLevel(id: 'c1', title: 'C1 - Cao cấp', subtitle: 'Trình độ tốt', badge: 'C1'),
    LanguageLevel(id: 'c2', title: 'C2 - Thành thạo', subtitle: 'Trình độ bản ngữ', badge: 'C2'),
  ];
}

/// Model cho tùy chọn ngôn ngữ
class LanguageOption {
  final String emoji;
  final String label;
  final String value;

  const LanguageOption({
    required this.emoji,
    required this.label,
    required this.value,
  });
}

/// Model cho trình độ ngôn ngữ theo chuẩn CEFR
class LanguageLevel {
  final String id;
  final String title;
  final String subtitle;
  final String badge;

  const LanguageLevel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  /// Chuyển đổi sang Map để tương thích với code hiện tại
  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'badge': badge,
    };
  }
}

