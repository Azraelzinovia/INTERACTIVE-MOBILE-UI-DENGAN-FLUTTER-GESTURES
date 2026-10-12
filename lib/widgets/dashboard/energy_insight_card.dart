import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/energy_calculator.dart';
import '../../models/energy_data.dart';

/// Dynamic AI Assistant insight card calculated strictly from current telemetry.
class EnergyInsightCard extends StatelessWidget {
  final EnergyData data;

  const EnergyInsightCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final insight = EnergyCalculator.generateInsight(data);
    final status = data.status;
    final statusColor = status.color;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withAlpha(80), width: 1),
        boxShadow: [
          BoxShadow(
            color: statusColor.withAlpha(20),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI Sparkle badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: statusColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PANS Energy Intelligence',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Analisis Keputusan Berbasis Data Real-Time',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Insight body text
          Text(
            insight,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          // Footnote metrics tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.eco_rounded,
                  color: AppColors.electricLime,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Clean Self-Sufficiency: ${data.selfSufficiencyRatio.toStringAsFixed(0)}% • CO₂ Dihindari: ${data.co2SavedKg.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
