import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/energy_recommendation.dart';
import '../../services/energy_service.dart';
import 'recommendation_card.dart';

/// Carousel implementing GESTURE 3: Swipe / Horizontal Drag.
/// Features smooth AnimatedSwitcher transitions, dot indicators, and child double-tap support.
class RecommendationCarousel extends StatefulWidget {
  final List<EnergyRecommendation> recommendations;
  final Function(String id)? onDoubleTapCard;

  const RecommendationCarousel({
    super.key,
    required this.recommendations,
    this.onDoubleTapCard,
  });

  @override
  State<RecommendationCarousel> createState() => _RecommendationCarouselState();
}

class _RecommendationCarouselState extends State<RecommendationCarousel> {
  int _currentIndex = 0;
  bool _isSwipingLeft = true;

  @override
  void didUpdateWidget(covariant RecommendationCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentIndex >= widget.recommendations.length) {
      _currentIndex = 0;
    }
  }

  void _next() {
    if (widget.recommendations.isEmpty) return;
    setState(() {
      _isSwipingLeft = true;
      _currentIndex = (_currentIndex + 1) % widget.recommendations.length;
    });
  }

  void _prev() {
    if (widget.recommendations.isEmpty) return;
    setState(() {
      _isSwipingLeft = false;
      _currentIndex =
          (_currentIndex - 1 + widget.recommendations.length) %
          widget.recommendations.length;
    });
  }

  void _goTo(int index) {
    if (index >= 0 && index < widget.recommendations.length) {
      setState(() {
        _isSwipingLeft = index > _currentIndex;
        _currentIndex = index;
      });
    }
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0.0;
    // Swipe left (negative velocity) -> next
    if (velocity < -150) {
      _next();
    }
    // Swipe right (positive velocity) -> previous
    else if (velocity > 150) {
      _prev();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: const Center(
          child: Text(
            'Tidak ada rekomendasi aktif untuk status ini.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    final total = widget.recommendations.length;
    final activeRec = widget.recommendations[_currentIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Navigation Header: Gesture hint + Position indicator + Nav Chevrons
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gesture 3 Label
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.electricLime.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.swipe_rounded,
                      size: 15,
                      color: AppColors.electricLime,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Swipe untuk Beralih Rekomendasi',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Page counter & manual controls
              Row(
                children: [
                  Text(
                    '${_currentIndex + 1} / $total',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _prev,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: _next,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Swipeable card area wrapped in GestureDetector
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: _handleHorizontalDragEnd,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              final inOffset = _isSwipingLeft
                  ? const Offset(0.35, 0.0)
                  : const Offset(-0.35, 0.0);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: inOffset,
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<String>('${activeRec.id}_${activeRec.isAccepted}'),
              child: RecommendationCard(
                recommendation: activeRec,
                onDoubleTap: () {
                  if (widget.onDoubleTapCard != null) {
                    widget.onDoubleTapCard!(activeRec.id);
                  } else {
                    try {
                      EnergyScope.of(context)
                          .toggleRecommendation(activeRec.id);
                    } catch (_) {}
                  }
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total, (index) {
            final isActive = index == _currentIndex;
            return GestureDetector(
              onTap: () => _goTo(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.electricLime
                      : AppColors.surfaceBorder,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.electricLime.withAlpha(120),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
