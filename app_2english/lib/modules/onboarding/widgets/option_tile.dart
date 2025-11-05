import 'package:flutter/material.dart';
import 'package:app_2english/core/theme/app_colors.dart';
import 'package:app_2english/modules/onboarding/widgets/badge.dart' show OnboardingBadge;

/// Widget hiển thị một tùy chọn trong danh sách với khả năng chọn single/multiple
class OptionTile extends StatelessWidget {

  const OptionTile({
    super.key,
    this.emoji,
    this.leadingIcon,
    required this.label,
    this.subtitle,
    this.badgeText,
    required this.selected,
    this.multiSelect = false,
    required this.onTap,
  });
  final String? emoji;
  final IconData? leadingIcon;
  final String label;
  final String? subtitle;
  final String? badgeText;
  final bool selected;
  final bool multiSelect;
  final VoidCallback onTap;

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
              _buildLeading(),
              const SizedBox(width: 12),
              Expanded(child: _buildContent(context)),
              _buildTrailing(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (badgeText != null) {
      return OnboardingBadge(text: badgeText!);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: emoji != null
            ? Text(emoji!, style: const TextStyle(fontSize: 18))
            : Icon(
                leadingIcon ?? Icons.circle,
                size: 18,
                color: Colors.black54,
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing() {
    if (multiSelect) {
      return Checkbox(
        value: selected,
        onChanged: (_) => onTap(),
        activeColor: AppColors.primaryColor,
        shape: const CircleBorder(),
      );
    }

    return Radio<bool>(
      value: true,
      groupValue: selected,
      onChanged: (_) => onTap(),
      activeColor: AppColors.primaryColor,
    );
  }
}

