import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_2english/modules/onboarding/common/onboarding_constants.dart';
import 'package:app_2english/modules/onboarding/utils/onboarding_strings.dart';
import 'package:app_2english/modules/onboarding/widgets/option_tile.dart';
import 'package:app_2english/core/theme/app_colors.dart';
import 'package:app_2english/modules/dashboard/screens/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // ========== State Variables ==========
  int _currentStepIndex = 0;
  String? _selectedLanguage;
  final Set<String> _selectedTopics = {};
  final Set<String> _selectedReasons = {};
  String? _selectedLevelId;

  static const int _totalSteps = 6;
  
  double get _progress => (_currentStepIndex + 1) / _totalSteps;

  // ========== Navigation Logic ==========
  void _goNext() {
    if (_currentStepIndex < _totalSteps - 1) {
      setState(() {
        _currentStepIndex += 1;
      });
    } else {
      _navigateToDashboard();
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

  void _navigateToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
      (route) => false,
    );
  }

  // ========== Validation & Actions ==========
  bool _canProceed() {
    switch (_currentStepIndex) {
      case 0:
        return _selectedLanguage != null;
      case 1:
        return _selectedTopics.isNotEmpty;
      case 2:
        return _selectedReasons.isNotEmpty;
      case 3:
        return _selectedLevelId != null;
      case 4:
      case 5:
        return true;
      default:
        return false;
    }
  }

  Future<void> _handlePrimaryAction() async {
    if (_currentStepIndex == 4) {
      await _showDebugSelectionsDialog();
    }
    _goNext();
  }

  // ========== Selection Toggle Logic ==========
  void _toggleTopic(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
    });
  }

  void _toggleReason(String reason) {
    setState(() {
      if (_selectedReasons.contains(reason)) {
        _selectedReasons.remove(reason);
      } else {
        _selectedReasons.add(reason);
      }
    });
  }

  // ========== Helper Methods ==========
  String _getButtonLabel() {
    switch (_currentStepIndex) {
      case 4:
        return OnboardingStrings.buttonComplete;
      case 5:
        return OnboardingStrings.buttonStart;
      default:
        return OnboardingStrings.buttonContinue;
    }
  }

  String _headerTitleForStep() {
    switch (_currentStepIndex) {
      case 0:
        return OnboardingStrings.titleLanguage;
      case 1:
        return OnboardingStrings.titleTopics;
      case 2:
        return OnboardingStrings.titleReasons;
      case 3:
        return OnboardingStrings.titleLevel;
      case 4:
        return OnboardingStrings.titleNotification;
      case 5:
        return OnboardingStrings.titleComplete;
      default:
        return OnboardingStrings.titleLanguage;
    }
  }

  String _headerSubtitleForStep() {
    switch (_currentStepIndex) {
      case 0:
        return OnboardingStrings.questionLanguage;
      case 1:
        return OnboardingStrings.questionTopics;
      case 2:
        return OnboardingStrings.questionReasons;
      case 3:
        return OnboardingStrings.questionLevel;
      case 4:
        return OnboardingStrings.questionNotification;
      case 5:
        return OnboardingStrings.questionComplete;
      default:
        return OnboardingStrings.questionLanguage;
    }
  }

  String _getSelectedLevelTitle() {
    if (_selectedLevelId == null) {
      return OnboardingStrings.debugNoSelection;
    }

    final level = OnboardingConstants.languageLevels
        .firstWhere(
          (lv) => lv.id == _selectedLevelId,
          orElse: () => OnboardingConstants.languageLevels.first,
        );
    return level.title;
  }

  Future<void> _showDebugSelectionsDialog() async {
    final language = _selectedLanguage ?? OnboardingStrings.debugNoSelection;
    final topics = _selectedTopics.isNotEmpty
        ? _selectedTopics.join(', ')
        : OnboardingStrings.debugNoSelection;
    final reasons = _selectedReasons.isNotEmpty
        ? _selectedReasons.join(', ')
        : OnboardingStrings.debugNoSelection;
    final level = _getSelectedLevelTitle();

    final content = '${OnboardingStrings.debugLanguageLabel} $language\n'
        '${OnboardingStrings.debugTopicsLabel} $topics\n'
        '${OnboardingStrings.debugReasonsLabel} $reasons\n'
        '${OnboardingStrings.debugLevelLabel} $level';

    debugPrint('[Onboarding] selections ->\n$content');
  }

  // ========== Build Methods ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStepContent(),
              ),
            ),
            _buildPrimaryButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return _OnboardingHeader(
      progress: _progress,
      onBack: _goBack,
      title: _headerTitleForStep(),
      question: _headerSubtitleForStep(),
      stepText: '${_currentStepIndex + 1}/$_totalSteps',
    );
  }

  Widget _buildPrimaryButton() {
    return Padding(
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
          onPressed: _canProceed() ? _handlePrimaryAction : null,
          child: Text(
            _getButtonLabel(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStepIndex) {
      case 0:
        return _buildLanguageStep();
      case 1:
        return _buildTopicsStep();
      case 2:
        return _buildReasonsStep();
      case 3:
        return _buildLevelStep();
      case 4:
        return const _NotificationCTA(key: ValueKey('step-noti'));
      case 5:
      default:
        return const _FinalThankYou(
          key: ValueKey('step-final'),
        );
    }
  }

  Widget _buildLanguageStep() {
    return Padding(
      key: const ValueKey('step-language'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ListView.builder(
        itemCount: OnboardingConstants.languages.length,
        itemBuilder: (context, index) {
          final lang = OnboardingConstants.languages[index];
          return OptionTile(
            emoji: lang.emoji,
            label: lang.label,
            selected: _selectedLanguage == lang.value,
            onTap: () => setState(() => _selectedLanguage = lang.value),
          );
        },
      ),
    );
  }

  Widget _buildTopicsStep() {
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
          final topic = OnboardingConstants.topics[index];
          final selected = _selectedTopics.contains(topic);
          return _TopicCard(
            icon: Icons.category,
            label: topic,
            selected: selected,
            onTap: () => _toggleTopic(topic),
          );
        },
      ),
    );
  }

  Widget _buildReasonsStep() {
    return Padding(
      key: const ValueKey('step-reasons'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ListView.builder(
        itemCount: OnboardingConstants.reasons.length,
        itemBuilder: (context, index) {
          final reason = OnboardingConstants.reasons[index];
          final selected = _selectedReasons.contains(reason);
          return OptionTile(
            leadingIcon: Icons.auto_awesome,
            label: reason,
            selected: selected,
            multiSelect: true,
            onTap: () => _toggleReason(reason),
          );
        },
      ),
    );
  }

  Widget _buildLevelStep() {
    return Padding(
      key: const ValueKey('step-level'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ListView.builder(
        itemCount: OnboardingConstants.languageLevels.length,
        itemBuilder: (context, index) {
          final level = OnboardingConstants.languageLevels[index];
          final selected = _selectedLevelId == level.id;
          return OptionTile(
            leadingIcon: Icons.timer,
            label: level.title,
            subtitle: level.subtitle,
            badgeText: level.badge,
            selected: selected,
            onTap: () => setState(() => _selectedLevelId = level.id),
          );
        },
      ),
    );
  }
}

// ========== Widgets ==========
class _OnboardingHeader extends StatefulWidget {
  final double progress;
  final VoidCallback onBack;
  final String title;
  final String question;
  final String stepText;

  const _OnboardingHeader({
    required this.progress,
    required this.onBack,
    required this.title,
    required this.question,
    required this.stepText,
  });

  @override
  State<_OnboardingHeader> createState() => _OnboardingHeaderState();
}

class _OnboardingHeaderState extends State<_OnboardingHeader> {
  double _previousProgress = 0;

  @override
  void didUpdateWidget(covariant _OnboardingHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
    }
  }

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
          _buildBackButton(),
          const SizedBox(height: 8),
          _buildTitle(),
          const SizedBox(height: 16),
          _buildProgressBar(),
          const SizedBox(height: 16),
          _buildQuestion(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        InkWell(
          onTap: widget.onBack,
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
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
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
              widget.stepText,
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
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: _previousProgress, end: widget.progress),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              onEnd: () {
                _previousProgress = widget.progress;
              },
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.white,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    return Center(
      child: Text(
        widget.question,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w800),
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

class _NotificationCTA extends StatefulWidget {
  const _NotificationCTA({super.key});

  @override
  State<_NotificationCTA> createState() => _NotificationCTAState();
}

class _NotificationCTAState extends State<_NotificationCTA> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
  const _FinalThankYou({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 80, color: Color(0xFF10B981)),
          SizedBox(height: 16),
          Text(
            'Cảm ơn bạn!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Bạn đã hoàn tất cài đặt ban đầu.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
