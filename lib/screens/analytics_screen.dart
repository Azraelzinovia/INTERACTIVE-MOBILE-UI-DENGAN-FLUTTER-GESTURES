import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/mock_energy_data.dart';
import '../services/energy_service.dart';
import '../widgets/charts/energy_comparison_chart.dart';
import '../widgets/common/section_header.dart';

/// Analytics screen showing hourly 24-hour generation & load curves,
/// net balance breakdown, and clean energy self-sufficiency metrics.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final energyService = EnergyScope.of(context);
    final currentData = energyService.currentData;
    const telemetry = MockEnergyData.hourlyCurve;

    // Calculate aggregated stats from telemetry
    final totalSolar = telemetry.fold<double>(
      0.0,
      (acc, item) => acc + item.solarKwh,
    );
    final totalConsumption = telemetry.fold<double>(
      0.0,
      (acc, item) => acc + item.consumptionKwh,
    );
    final netDayBalance = totalSolar - totalConsumption;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Energy Analytics'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insights_rounded,
                  size: 14,
                  color: AppColors.electricLime,
                ),
                SizedBox(width: 6),
                Text(
                  'Data Simulasi 24 Jam',
                  style: TextStyle(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Daily Aggregation Hero Row
            Row(
              children: [
                Expanded(
                  child: _SummaryBox(
                    label: 'Total Produksi Surya',
                    value: '${totalSolar.toStringAsFixed(1)} kWh',
                    icon: Icons.solar_power_rounded,
                    accentColor: AppColors.solarGold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryBox(
                    label: 'Total Beban Listrik',
                    value: '${totalConsumption.toStringAsFixed(1)} kWh',
                    icon: Icons.bolt_rounded,
                    accentColor: AppColors.consumptionOrange,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryBox(
                    label: 'Net Neraca Hari Ini',
                    value:
                        '${netDayBalance > 0 ? '+' : ''}${netDayBalance.toStringAsFixed(1)} kWh',
                    icon: Icons.balance_rounded,
                    accentColor: netDayBalance >= 0
                        ? AppColors.electricLime
                        : AppColors.alertRed,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 1. Primary 24-Hour Continuous Comparison Chart
            const SectionHeader(
              title: 'Profil Pembangkitan & Beban',
              subtitle: 'Kurva perbandingan solar PV dan konsumsi per jam',
              icon: Icons.show_chart_rounded,
            ),
            const SizedBox(height: 8),
            const EnergyComparisonChart(telemetry: telemetry),

            const SizedBox(height: 24),

            // 2. Hourly Balance Bar Breakdown
            const SectionHeader(
              title: 'Distribusi Surplus / Defisit per Jam',
              subtitle: 'Visualisasi jam kelebihan daya vs jam defisit',
              icon: Icons.bar_chart_rounded,
            ),
            const SizedBox(height: 8),
            const _HourlyBalanceBarChart(telemetry: telemetry),

            const SizedBox(height: 24),

            // 3. Clean Energy Coverage & SDG Impact Card
            _SelfSufficiencyGaugeCard(
              solarKwh: currentData.solarProduction,
              consumptionKwh: currentData.energyConsumption,
              co2SavedKg: currentData.co2SavedKg,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _SummaryBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Horizontal bar graph of surplus/deficit per hour
class _HourlyBalanceBarChart extends StatelessWidget {
  final List<HourlyTelemetry> telemetry;

  const _HourlyBalanceBarChart({required this.telemetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Neraca Daya per Jam (kW)',
                style: AppTextStyles.titleMedium,
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.electricLime,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Surplus',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.consumptionOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Defisit',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: telemetry.map((item) {
                final balance = item.netBalance;
                final isSurplus = balance >= 0;
                // Normalize bar height based on max balance ~4.0
                final heightFactor = (balance.abs() / 4.0).clamp(0.08, 1.0);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 90 * heightFactor,
                          decoration: BoxDecoration(
                            color: isSurplus
                                ? AppColors.electricLime
                                : AppColors.consumptionOrange,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (item.hour % 4 == 0)
                          Text(
                            '${item.hour}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 9,
                            ),
                          )
                        else
                          const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular self-sufficiency gauge card
class _SelfSufficiencyGaugeCard extends StatelessWidget {
  final double solarKwh;
  final double consumptionKwh;
  final double co2SavedKg;

  const _SelfSufficiencyGaugeCard({
    required this.solarKwh,
    required this.consumptionKwh,
    required this.co2SavedKg,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = consumptionKwh > 0
        ? ((solarKwh / consumptionKwh) * 100).clamp(0.0, 100.0)
        : 100.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF13283E), Color(0xFF0F1A2F)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.electricLime.withAlpha(90)),
      ),
      child: Row(
        children: [
          // Circular gauge
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: ratio / 100.0,
                  backgroundColor: AppColors.surfaceBorder,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.electricLime,
                  ),
                  strokeWidth: 8,
                ),
                Center(
                  child: Text(
                    '${ratio.toInt()}%',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          // Description & SDG note
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kemandirian Energi Bersih',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Proporsi beban listrik rumah yang dipenuhi langsung oleh energi surya fotovoltaik.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.forest_rounded,
                      color: AppColors.electricLime,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Emisi CO₂ ditekan: ${co2SavedKg.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        color: AppColors.electricLime,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
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
