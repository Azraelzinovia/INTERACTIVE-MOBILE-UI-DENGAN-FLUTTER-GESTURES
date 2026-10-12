import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/energy_data.dart';

/// Row of three proportional metric cards: Solar, Consumption, Battery.
class EnergyMetricsRow extends StatelessWidget {
  final EnergyData data;

  const EnergyMetricsRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Solar Production
        Expanded(
          child: _MetricCard(
            title: 'Solar PV',
            value: data.solarProduction.toStringAsFixed(1),
            unit: 'kWh',
            icon: Icons.wb_sunny_rounded,
            accentColor: AppColors.solarGold,
            sublabel: 'Produksi Aktif',
            progress: (data.solarProduction / 8.0).clamp(0.0, 1.0),
          ),
        ),

        const SizedBox(width: 10),

        // 2. Household Consumption
        Expanded(
          child: _MetricCard(
            title: 'Konsumsi',
            value: data.energyConsumption.toStringAsFixed(1),
            unit: 'kWh',
            icon: Icons.home_rounded,
            accentColor: AppColors.consumptionOrange,
            sublabel: 'Beban Rumah',
            progress: (data.energyConsumption / 8.0).clamp(0.0, 1.0),
          ),
        ),

        const SizedBox(width: 10),

        // 3. Battery Storage
        Expanded(
          child: _MetricCard(
            title: 'Baterai',
            value: '${data.batteryPercentage}',
            unit: '%',
            icon: data.batteryPercentage > 25
                ? Icons.battery_charging_full_rounded
                : Icons.battery_alert_rounded,
            accentColor: data.batteryPercentage > 25
                ? AppColors.batteryCyan
                : AppColors.alertRed,
            sublabel:
                '${data.currentBatteryKwh.toStringAsFixed(1)} kWh Tersedia',
            progress: data.batteryPercentage / 100.0,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color accentColor;
  final String sublabel;
  final double progress;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accentColor,
    required this.sublabel,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Title Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Numerical Value & Unit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Micro Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceBorder,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 4,
            ),
          ),

          const SizedBox(height: 6),

          // Sublabel caption
          Text(
            sublabel,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
