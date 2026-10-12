import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/energy_calculator.dart';
import '../../models/energy_data.dart';
import '../common/status_badge.dart';

/// Hero Energy Status Card presenting real-time net energy balance,
/// production, consumption, and high-level recommendation summary.
class EnergyStatusCard extends StatelessWidget {
  final EnergyData energyData;

  const EnergyStatusCard({super.key, required this.energyData});

  @override
  Widget build(BuildContext context) {
    final status = energyData.status;
    final balance = energyData.energyBalance;
    final balanceFormatted = EnergyCalculator.formatBalance(balance);
    final statusColor = status.color;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withAlpha(90), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withAlpha(30),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient energy gradient mesh
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withAlpha(20),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Label and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bolt_rounded, color: statusColor, size: 20),
                        const SizedBox(width: 6),
                        const Text(
                          'NET ENERGY BALANCE',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    StatusBadge(status: status),
                  ],
                ),

                const SizedBox(height: 14),

                // Large Main Number: Net Balance
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      balanceFormatted,
                      style: AppTextStyles.displayMetric.copyWith(
                        color: balance >= 0
                            ? AppColors.electricLime
                            : AppColors.consumptionOrange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        balance >= 0 ? 'SURPLUS DAYA' : 'DEFISIT DAYA',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(
                  status.shortDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(color: AppColors.surfaceBorderSubtle, height: 1),
                const SizedBox(height: 16),

                // Comparison breakdown row: Production vs Consumption
                Row(
                  children: [
                    // Solar production item
                    Expanded(
                      child: _MetricMiniItem(
                        icon: Icons.solar_power_rounded,
                        iconColor: AppColors.solarGold,
                        label: 'Produksi Surya',
                        value:
                            '${energyData.solarProduction.toStringAsFixed(1)} kWh',
                      ),
                    ),

                    Container(
                      height: 36,
                      width: 1,
                      color: AppColors.surfaceBorder,
                    ),

                    // Consumption item
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: _MetricMiniItem(
                          icon: Icons.electric_meter_rounded,
                          iconColor: AppColors.consumptionOrange,
                          label: 'Konsumsi Rumah',
                          value:
                              '${energyData.energyConsumption.toStringAsFixed(1)} kWh',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricMiniItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _MetricMiniItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
