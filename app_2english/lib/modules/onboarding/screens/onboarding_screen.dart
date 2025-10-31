import 'package:flutter/material.dart';
import '../common/onboarding_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  int _currentStepIndex = 0;
  String? _selectedLanguage;
  final Set<String> _selectedTopics = {};
  final Set<String> _selectedReasons = {};
  String? _selectedLevelId;

  static const int _totalSteps = 6;
  double get _progress => (_currentStepIndex + 1) / _totalSteps;

  void _goNext() {
    if (_currentStepIndex < _totalSteps - 1) {
      setState(() {
        _currentStepIndex += 1;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  void _goBack() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Unified layout for all steps (no app bar)
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _LanguageHeader(
              progress: _progress,
              onBack: _goBack,
              title: _headerTitleForStep(),
              question: _headerSubtitleForStep(),
              stepText: '${_currentStepIndex + 1}/$_totalSteps',
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStepContent(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _canProceed() ? _goNext : null,
                  child: Text(
                    _currentStepIndex == 4
                        ? 'Hoàn thành'
                        : _currentStepIndex == 5
                            ? 'Học ngay'
                            : 'Tiếp tục',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_currentStepIndex == 0) return _selectedLanguage != null;
    if (_currentStepIndex == 1) return _selectedTopics.isNotEmpty;
    if (_currentStepIndex == 2) return _selectedReasons.isNotEmpty;
    if (_currentStepIndex == 3) return _selectedLevelId != null;
    // Steps 5 and 6 are informational; allow proceeding
    return true;
  }

  Widget _buildStepContent() {
    switch (_currentStepIndex) {
      case 0:
        return Padding(
          key: const ValueKey('step-language'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              ...OnboardingConstants.languages.map((lang) {
                return _OptionTile(
                  emoji: lang.emoji,
                  label: lang.label,
                  selected: _selectedLanguage == lang.value,
                  onTap: () => setState(() => _selectedLanguage = lang.value),
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        );
      case 1:
        return Padding(
          key: const ValueKey('step-topics'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
            ),
            itemCount: OnboardingConstants.topics.length,
            itemBuilder: (context, index) {
              final String t = OnboardingConstants.topics[index];
              final bool selected = _selectedTopics.contains(t);
              return _TopicCard(
                icon: Icons.category,
                label: t,
                selected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedTopics.remove(t);
                    } else {
                      _selectedTopics.add(t);
                    }
                  });
                },
              );
            },
          ),
        );
      case 2:
        return Padding(
          key: const ValueKey('step-reasons'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: ListView(
            children: OnboardingConstants.reasons.map((r) {
              final bool selected = _selectedReasons.contains(r);
              return _OptionTile(
                leadingIcon: Icons.auto_awesome,
                label: r,
                selected: selected,
                multiSelect: true,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedReasons.remove(r);
                    } else {
                      _selectedReasons.add(r);
                    }
                  });
                },
              );
            }).toList(),
          ),
        );
      case 3:
        return Padding(
          key: const ValueKey('step-level'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: ListView(
            children: OnboardingConstants.languageLevels.map((lv) {
              final bool selected = _selectedLevelId == lv.id;
              return _OptionTile(
                leadingIcon: Icons.timer,
                label: lv.title,
                subtitle: lv.subtitle,
                badgeText: lv.badge,
                selected: selected,
                onTap: () => setState(() => _selectedLevelId = lv.id),
              );
            }).toList(),
          ),
        );
      case 4:
        return _NotificationCTA(key: const ValueKey('step-noti'));
      case 5:
      default:
        return _FinalThankYou(key: const ValueKey('step-final'), onStart: _goNext);
    }
  }

  String _headerTitleForStep() {
    switch (_currentStepIndex) {
      case 0:
        return 'Chọn ngôn ngữ';
      case 1:
        return 'Chọn chủ đề quan tâm';
      case 2:
        return 'Vì sao bạn học tiếng Anh?';
      case 3:
        return 'Trình độ tiếng Anh hiện tại';
      case 4:
        return 'Bật thông báo';
      case 5:
        return 'Hoàn tất';
      default:
        return 'Chọn ngôn ngữ';
    }
  }

  String _headerSubtitleForStep() {
    switch (_currentStepIndex) {
      case 0:
        return 'Bạn muốn học ngôn ngữ nào?';
      case 1:
        return 'Bạn có thể chọn nhiều mục';
      case 2:
        return 'Chọn các lý do phù hợp';
      case 3:
        return 'Hãy chọn mức độ phù hợp với bạn';
      case 4:
        return 'Cho phép gửi thông báo để không bỏ lỡ bài học.';
      case 5:
        return 'Cảm ơn bạn đã cung cấp thông tin!';
      default:
        return 'Bạn muốn học ngôn ngữ nào?';
    }
  }
}

class _LanguageHeader extends StatelessWidget {
  final double progress;
  final VoidCallback onBack;
  final String title;
  final String question;
  final String stepText;

  const _LanguageHeader({
    required this.progress,
    required this.onBack,
    required this.title,
    required this.question,
    required this.stepText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryColor, AppColors.fieldFill],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.chevron_left, color: Colors.black87),
                ),
              ),
              const Spacer(),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              question,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String? emoji;
  final IconData? leadingIcon;
  final String label;
  final String? subtitle;
  final String? badgeText;
  final bool selected;
  final bool multiSelect;
  final VoidCallback onTap;

  const _OptionTile({
    this.emoji,
    this.leadingIcon,
    required this.label,
    this.subtitle,
    this.badgeText,
    required this.selected,
    this.multiSelect = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: selected ? AppColors.primaryColor : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              if (badgeText != null)
                _Badge(text: badgeText!)
              else
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: emoji != null
                        ? Text(emoji!, style: const TextStyle(fontSize: 18))
                        : Icon(leadingIcon ?? Icons.circle, size: 18, color: Colors.black54),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.bodyLarge),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              if (multiSelect)
                Checkbox(
                  value: selected,
                  onChanged: (_) => onTap(),
                  activeColor: AppColors.primaryColor,
                  shape: const CircleBorder(),
                )
              else
                Radio<bool>(
                  value: true,
                  groupValue: selected,
                  onChanged: (_) => onTap(),
                  activeColor: AppColors.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TopicCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primaryColor : AppColors.borderColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _NotificationCTA extends StatelessWidget {
  const _NotificationCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_active, size: 72, color: Color(0xFF3B82F6)),
          SizedBox(height: 16),
          Text(
            'Cho phép thông báo',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Nhận nhắc nhở học tập, thông báo bài mới và tiến độ mỗi ngày.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FinalThankYou extends StatelessWidget {
  final VoidCallback onStart;
  const _FinalThankYou({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Color(0xFF10B981)),
          const SizedBox(height: 16),
          const Text(
            'Cảm ơn bạn!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bạn đã hoàn tất cài đặt ban đầu.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

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


