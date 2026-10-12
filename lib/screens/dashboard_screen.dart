import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../services/energy_service.dart';
import '../widgets/common/app_header.dart';
import '../widgets/common/section_header.dart';
import '../widgets/dashboard/energy_flow_visualization.dart';
import '../widgets/dashboard/energy_insight_card.dart';
import '../widgets/dashboard/energy_metric_card.dart';
import '../widgets/dashboard/energy_status_card.dart';
import '../widgets/recommendations/recommendation_carousel.dart';
import '../widgets/simulation/custom_simulator_modal.dart';

/// Primary Dashboard screen featuring the Hero Status Card,
/// Energy Metrics, Interactive Pinchable Flow, Insight, and Swipeable Recommendations.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final energyService = EnergyScope.of(context);
    final currentData = energyService.currentData;
    final activeRecommendations = energyService.activeScenarioRecommendations;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CustomSimulatorModal.show(context),
        backgroundColor: AppColors.electricLime,
        foregroundColor: AppColors.textOnAccent,
        icon: const Icon(Icons.tune_rounded),
        label: const Text(
          'Simulasi Kustom',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Fixed Header
          const AppHeader(),

          // Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Optional Banner when Custom Mode is Active
                  if (energyService.isCustomMode) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.electricLime.withAlpha(150),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricLime.withAlpha(25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.electricLime.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: AppColors.electricLime,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mode Simulasi Kustom Aktif',
                                  style: TextStyle(
                                    color: AppColors.electricLime,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Solar ${currentData.solarProduction} kW • Beban ${currentData.energyConsumption} kW • Baterai ${currentData.batteryPercentage}%',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => CustomSimulatorModal.show(context),
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: AppColors.electricLime,
                            ),
                            child: const Text('Ubah'),
                          ),
                          TextButton(
                            onPressed: () => energyService.resetToPreset(0),
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: AppColors.textMuted,
                            ),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 1. Hero Energy Status Card
                  EnergyStatusCard(energyData: currentData),

                  const SizedBox(height: 18),

                  // 2. Three Metric Cards in Row
                  const SectionHeader(
                    title: 'Metrik Daya Real-Time',
                    subtitle: 'Pengukuran telemetri terkini',
                    icon: Icons.speed_rounded,
                  ),
                  const SizedBox(height: 8),
                  EnergyMetricsRow(data: currentData),

                  const SizedBox(height: 20),

                  // 3. Interactive Energy Flow Visualization (Gesture 2: Scale/Pinch)
                  const SectionHeader(
                    title: 'Visualisasi Aliran Energi',
                    subtitle: 'Pinch 2 jari untuk memperbesar/memperkecil',
                    icon: Icons.hub_rounded,
                  ),
                  const SizedBox(height: 8),
                  EnergyFlowVisualization(data: currentData),

                  const SizedBox(height: 20),

                  // 4. Dynamic Energy Intelligence Insight
                  const SectionHeader(
                    title: 'Energy Decision Insight',
                    subtitle: 'Rekomendasi terkomputasi otomatis',
                    icon: Icons.psychology_rounded,
                  ),
                  const SizedBox(height: 8),
                  EnergyInsightCard(data: currentData),

                  const SizedBox(height: 20),

                  // 5. Smart Recommendations Carousel (Gesture 3: Swipe & Gesture 1: Double Tap)
                  const SectionHeader(
                    title: 'Smart Energy Assistant',
                    subtitle:
                        'Swipe ke samping & Double-tap kartu untuk menyetujui',
                    icon: Icons.auto_awesome_motion_rounded,
                  ),
                  const SizedBox(height: 8),
                  RecommendationCarousel(
                    recommendations: activeRecommendations,
                    onDoubleTapCard: (id) {
                      final accepted = energyService.toggleRecommendation(id);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 1800),
                          content: Row(
                            children: [
                              Icon(
                                accepted
                                    ? Icons.check_circle_rounded
                                    : Icons.remove_circle_outline_rounded,
                                color: accepted
                                    ? AppColors.electricLime
                                    : AppColors.solarGold,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  accepted
                                      ? 'Rekomendasi disetujui (Status: Accepted)'
                                      : 'Persetujuan rekomendasi dibatalkan (Status: Pending)',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
