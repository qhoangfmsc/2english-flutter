import 'package:flutter/material.dart';
import 'package:app_2english/core/theme/app_colors.dart';
import 'package:app_2english/core/widgets/app_search_input.dart';

class VocabScreen extends StatefulWidget {
  const VocabScreen({super.key});

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  // ========== State: filters, search, data ==========
  final TextEditingController _searchController = TextEditingController();

  String _activeFilter = 'Tất cả'; // Tất cả, Mới, Đang học, Thành thạo
  String _activeSort = 'Mới nhất'; // Mới nhất, A-Z, Đến hạn ôn 

  final List<String> _filters = const [
    'Tất cả',
    'Mới',
    'Đang học',
    'Thành thạo',
  ];

  final List<_VocabItem> _allVocab = [
    _VocabItem(
      word: 'ubiquitous',
      meaning: 'có mặt khắp nơi',
      example: 'Smartphones have become ubiquitous in modern society.',
      level: _VocabLevel.learning,
      tags: const ['IELTS', 'Academic'],
      progressPercent: 0.6,
      reviewDueInDays: 1,
      addedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    _VocabItem(
      word: 'meticulous',
      meaning: 'tỉ mỉ, cẩn thận',
      example: 'She is meticulous in her work.',
      level: _VocabLevel.mastered,
      tags: const ['Work'],
      progressPercent: 1.0,
      reviewDueInDays: 7,
      addedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    _VocabItem(
      word: 'serendipity',
      meaning: 'sự tình cờ may mắn',
      example: 'It was pure serendipity that we met.',
      level: _VocabLevel.newWord,
      tags: const ['Daily'],
      progressPercent: 0.1,
      reviewDueInDays: 0,
      addedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _VocabItem(
      word: 'alleviate',
      meaning: 'làm giảm bớt, xoa dịu',
      example: 'This medicine will alleviate your pain.',
      level: _VocabLevel.learning,
      tags: const ['Health'],
      progressPercent: 0.4,
      reviewDueInDays: 2,
      addedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // ========== Logic: filter, sort, stats ==========
  List<_VocabItem> get _visibleVocab {
    final query = _searchController.text.trim().toLowerCase();

    List<_VocabItem> filtered = _allVocab.where((v) {
      final matchText =
          v.word.toLowerCase().contains(query) ||
          v.meaning.toLowerCase().contains(query) ||
          v.tags.any((t) => t.toLowerCase().contains(query));

      final matchFilter = switch (_activeFilter) {
        'Mới' => v.level == _VocabLevel.newWord,
        'Đang học' => v.level == _VocabLevel.learning,
        'Thành thạo' => v.level == _VocabLevel.mastered,
        _ => true,
      };

      return matchText && matchFilter;
    }).toList();

    switch (_activeSort) {
      case 'A-Z':
        filtered.sort(
          (a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()),
        );
        break;
      case 'Đến hạn ôn':
        filtered.sort((a, b) => a.reviewDueInDays.compareTo(b.reviewDueInDays));
        break;
      default: // Mới nhất
        filtered.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    }

    return filtered;
  }

  int get _totalWords => _allVocab.length;
  int get _learningWords =>
      _allVocab.where((v) => v.level == _VocabLevel.learning).length;
  int get _masteredWords =>
      _allVocab.where((v) => v.level == _VocabLevel.mastered).length;
  int get _dueToday => _allVocab.where((v) => v.reviewDueInDays <= 0).length;

  // ========== Build Methods ==========
  @override
  Widget build(BuildContext context) {
    return _renderVocab();
  }

  // ========== Main render function ==========
  Widget _renderVocab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _VocabHeaderSection(
              total: _totalWords,
              learning: _learningWords,
              mastered: _masteredWords,
              due: _dueToday,
              onAddPressed: _onAddNew,
            ),
            _VocabListSection(
              searchController: _searchController,
              filters: _filters,
              activeFilter: _activeFilter,
              onChangeFilter: (f) => setState(() => _activeFilter = f),
              items: _visibleVocab,
              onReview: _onReviewItem,
              onAddNew: _onAddNew,
            ),
          ],
        ),
      ),
    );
  }

  // old builder methods were refactored into section widgets above

  void _onAddNew() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tính năng thêm từ sẽ sớm có!'),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onReviewItem(_VocabItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ôn tập: ${item.word}'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ========== Models ==========
enum _VocabLevel { newWord, learning, mastered }

class _VocabItem {
  _VocabItem({
    required this.word,
    required this.meaning,
    required this.example,
    required this.level,
    required this.tags,
    required this.progressPercent,
    required this.reviewDueInDays,
    required this.addedAt,
  });

  final String word;
  final String meaning;
  final String example;
  final _VocabLevel level;
  final List<String> tags;
  final double progressPercent; // 0..1
  final int reviewDueInDays; // 0 = due today
  final DateTime addedAt;
}

// ========== Widgets ==========
class _VocabHeaderSection extends StatelessWidget {
  const _VocabHeaderSection({
    required this.total,
    required this.learning,
    required this.mastered,
    required this.due,
    required this.onAddPressed,
  });

  final int total;
  final int learning;
  final int mastered;
  final int due;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Từ vựng của bạn',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Material(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onAddPressed,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Thêm từ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _VocabListSection extends StatelessWidget {
  const _VocabListSection({
    required this.searchController,
    required this.filters,
    required this.activeFilter,
    required this.onChangeFilter,
    required this.items,
    required this.onReview,
    required this.onAddNew,
  });

  final TextEditingController searchController;
  final List<String> filters;
  final String activeFilter;
  final void Function(String) onChangeFilter;
  final List<_VocabItem> items;
  final void Function(_VocabItem) onReview;
  final VoidCallback onAddNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchInput(
          hintText: 'Tìm từ của bạn',
          controller: searchController,
          onSearch: () {},
          onChanged: (_) {},
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters
                .map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: activeFilter == f,
                      onSelected: (_) => onChangeFilter(f),
                      selectedColor: AppColors.primaryColor.withOpacity(0.15),
                      showCheckmark: true,
                      checkmarkColor: AppColors.primaryColor,
                      labelStyle: TextStyle(
                        color: activeFilter == f
                            ? AppColors.primaryColor
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      side: const BorderSide(color: AppColors.borderColor),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.inbox_outlined,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Không có từ phù hợp',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Hãy thử từ khóa khác hoặc thêm từ mới',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: onAddNew,
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Thêm từ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: items
                .map(
                  (v) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _VocabTile(item: v, onReview: onReview),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

// Old card variant (kept for reference) has been removed in favor of compact tile

class _VocabTile extends StatelessWidget {
  const _VocabTile({required this.item, required this.onReview});

  final _VocabItem item;
  final void Function(_VocabItem) onReview;

  Color _levelColor(_VocabLevel level) {
    switch (level) {
      case _VocabLevel.newWord:
        return AppColors.info;
      case _VocabLevel.learning:
        return AppColors.warning;
      case _VocabLevel.mastered:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color tone = _levelColor(item.level);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Text(
                        item.word,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tone.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          item.level == _VocabLevel.mastered
                              ? 'Thành thạo'
                              : item.level == _VocabLevel.learning
                              ? 'Đang học'
                              : 'Mới',
                          style: TextStyle(
                            color: tone,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.meaning,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _ProgressRing(
              percent: item.progressPercent,
              size: 38,
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.percent,
    this.size = 56,
    this.strokeWidth = 6,
  });

  final double percent;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final int display = (percent * 100).clamp(0, 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: percent,
            strokeWidth: strokeWidth,
            color: AppColors.primaryColor,
            backgroundColor: AppColors.borderColor,
          ),
          Center(
            child: Text(
              '$display%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
