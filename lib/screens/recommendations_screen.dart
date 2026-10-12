import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../services/energy_service.dart';
import '../widgets/recommendations/recommendation_card.dart';

/// Screen listing all smart recommendations with filtering,
/// detailed triggers/actions, and double-tap toggle interactions.
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  // Filter index: 0 = All, 1 = Pending, 2 = Accepted
  int _filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final energyService = EnergyScope.of(context);
    final allRecommendations = energyService.recommendations;
    final acceptedCount = energyService.acceptedCount;
    final pendingCount = allRecommendations.length - acceptedCount;

    final filteredList = allRecommendations.where((r) {
      if (_filterIndex == 1) return !r.isAccepted;
      if (_filterIndex == 2) return r.isAccepted;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rekomendasi Cerdas'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: AppColors.electricLime,
                ),
                const SizedBox(width: 6),
                Text(
                  '$acceptedCount / ${allRecommendations.length} Disetujui',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner explaining Gesture 1 (Double Tap)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: AppColors.electricLime,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Petunjuk Gesture (Double Tap)',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Ketuk 2 kali pada kartu mana pun untuk menerima (Accept) atau membatalkan (Pending) rekomendasi efisiensi energi.',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Segment Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterTab(
                  label: 'Semua (${allRecommendations.length})',
                  isSelected: _filterIndex == 0,
                  onTap: () => setState(() => _filterIndex = 0),
                ),
                const SizedBox(width: 8),
                _FilterTab(
                  label: 'Pending ($pendingCount)',
                  isSelected: _filterIndex == 1,
                  onTap: () => setState(() => _filterIndex = 1),
                ),
                const SizedBox(width: 8),
                _FilterTab(
                  label: 'Disetujui ($acceptedCount)',
                  isSelected: _filterIndex == 2,
                  onTap: () => setState(() => _filterIndex = 2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // List of Recommendation Cards
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada rekomendasi pada filter ini.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final rec = filteredList[index];
                      return RecommendationCard(
                        recommendation: rec,
                        onDoubleTap: () {
                          final accepted = energyService.toggleRecommendation(
                            rec.id,
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(milliseconds: 1600),
                              content: Text(
                                accepted
                                    ? '"${rec.title}" disetujui (Accepted)'
                                    : '"${rec.title}" dikembalikan ke antrean (Pending)',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.electricLime : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.electricLime
                  : AppColors.surfaceBorder,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textOnAccent
                    : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
