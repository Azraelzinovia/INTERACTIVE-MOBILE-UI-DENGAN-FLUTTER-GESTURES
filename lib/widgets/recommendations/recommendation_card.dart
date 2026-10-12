import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/energy_recommendation.dart';

/// Interactive Recommendation Card implementing GESTURE 1: Double Tap.
/// Double-tapping toggles acceptance state with immediate high-contrast visual feedback.
class RecommendationCard extends StatefulWidget {
  final EnergyRecommendation recommendation;
  final VoidCallback onDoubleTap;
  final bool compact;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onDoubleTap,
    this.compact = false,
  });

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.04), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    _animController.forward(from: 0.0);
    widget.onDoubleTap();
  }

  @override
  Widget build(BuildContext context) {
    final rec = widget.recommendation;
    final isAccepted = rec.isAccepted;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: _handleDoubleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(widget.compact ? 16 : 20),
          decoration: BoxDecoration(
            color: isAccepted ? const Color(0xFF0F2624) : AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isAccepted
                  ? AppColors.electricLime
                  : AppColors.surfaceBorder,
              width: isAccepted ? 2.0 : 1.0,
            ),
            boxShadow: [
              if (isAccepted)
                BoxShadow(
                  color: AppColors.electricLime.withAlpha(45),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                )
              else
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar: Priority Badge + Double Tap Acceptance Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Priority tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(rec.priority).withAlpha(30),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _getPriorityColor(rec.priority).withAlpha(100),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          rec.icon,
                          size: 13,
                          color: _getPriorityColor(rec.priority),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rec.priority,
                          style: TextStyle(
                            color: _getPriorityColor(rec.priority),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Acceptance status badge (Visual evidence of Gesture 1)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isAccepted
                          ? AppColors.electricLime
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isAccepted
                            ? AppColors.electricLime
                            : AppColors.surfaceBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAccepted
                              ? Icons.check_circle_rounded
                              : Icons.schedule_rounded,
                          size: 14,
                          color: isAccepted
                              ? AppColors.textOnAccent
                              : AppColors.solarGold,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isAccepted
                              ? 'RECOMMENDATION ACCEPTED'
                              : 'RECOMMENDATION PENDING',
                          style: TextStyle(
                            color: isAccepted
                                ? AppColors.textOnAccent
                                : AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Title
              Text(
                rec.title,
                style: AppTextStyles.titleLarge.copyWith(
                  color: isAccepted
                      ? AppColors.electricLime
                      : AppColors.textPrimary,
                  fontSize: widget.compact ? 16 : 18,
                ),
              ),

              const SizedBox(height: 6),

              // Summary
              Text(
                rec.summary,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: widget.compact ? 13 : 14,
                ),
              ),

              const SizedBox(height: 12),

              // Condition Trigger Box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.surfaceBorderSubtle,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.radar_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Kondisi Pemicu:',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      rec.triggerCondition,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: 13,
                          color: AppColors.electricLime,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Estimasi Manfaat:',
                          style: TextStyle(
                            color: AppColors.electricLime,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      rec.impactEstimated,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Double Tap Interactive Instruction Hint
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isAccepted
                      ? AppColors.electricLime.withAlpha(20)
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isAccepted
                        ? AppColors.electricLime.withAlpha(80)
                        : AppColors.surfaceBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 15,
                      color: isAccepted
                          ? AppColors.electricLime
                          : AppColors.solarGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAccepted
                          ? 'Double Tap kartu untuk membatalkan persetujuan'
                          : 'Double Tap kartu untuk MENERIMA rekomendasi',
                      style: TextStyle(
                        color: isAccepted
                            ? AppColors.electricLime
                            : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'URGENT':
        return AppColors.alertRed;
      case 'HIGH':
        return AppColors.consumptionOrange;
      case 'RECOMMENDED':
        return AppColors.electricLime;
      default:
        return AppColors.batteryCyan;
    }
  }
}
