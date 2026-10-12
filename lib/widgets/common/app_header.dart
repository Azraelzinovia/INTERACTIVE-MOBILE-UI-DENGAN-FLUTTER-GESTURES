import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/energy_service.dart';
import '../simulation/custom_simulator_modal.dart';
import 'status_badge.dart';

/// Top header displaying PANS ENERGI branding, system status, and scenario switcher.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final energyService = EnergyScope.of(context);
    final currentData = energyService.currentData;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceBorderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Brand Logo & Stylized Glyph
            const _PansBrandLogo(),
            const SizedBox(width: 12),

            // Titles & Period
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'PANS ENERGI',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: energyService.isCustomMode
                              ? AppColors.solarGold.withAlpha(30)
                              : AppColors.electricLime.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          energyService.isCustomMode
                              ? 'LIVE KUSTOM'
                              : 'AI ASSIST',
                          style: TextStyle(
                            color: energyService.isCustomMode
                                ? AppColors.solarGold
                                : AppColors.electricLime,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    energyService.isCustomMode
                        ? 'Kustom • ${currentData.scenarioTitle}'
                        : 'Simulasi • ${currentData.scenarioTitle}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // Direct Custom Simulator Button (For Presentations)
            IconButton(
              tooltip: 'Studio Simulasi Kustom',
              style: IconButton.styleFrom(
                backgroundColor: energyService.isCustomMode
                    ? AppColors.electricLime.withAlpha(45)
                    : AppColors.surfaceElevated,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: energyService.isCustomMode
                        ? AppColors.electricLime
                        : AppColors.surfaceBorder,
                    width: energyService.isCustomMode ? 1.5 : 1,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.tune_rounded,
                size: 20,
                color: AppColors.electricLime,
              ),
              onPressed: () => CustomSimulatorModal.show(context),
            ),

            const SizedBox(width: 6),

            // Scenario Switcher Button
            IconButton(
              tooltip: 'Pilih Skenario Bawaan',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceElevated,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.surfaceBorder),
                ),
              ),
              icon: const Icon(
                Icons.layers_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
              onPressed: () => _showScenarioDialog(context, energyService),
            ),

            const SizedBox(width: 6),

            // Live status badge
            StatusBadge(status: currentData.status, compact: true),
          ],
        ),
      ),
    );
  }

  void _showScenarioDialog(BuildContext context, EnergyService service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withAlpha(100),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Skenario Simulasi',
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih skenario preset bawaan atau atur sendiri aliran energi Anda.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 14),

              // Custom Simulator Trigger Card
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  CustomSimulatorModal.show(context);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF16382D), Color(0xFF0F2236)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: service.isCustomMode
                          ? AppColors.electricLime
                          : AppColors.electricLime.withAlpha(120),
                      width: service.isCustomMode ? 1.8 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricLime.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.electricLime.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.electricLime,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Studio Simulasi Kustom',
                                  style: TextStyle(
                                    color: AppColors.electricLime,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (service.isCustomMode) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.electricLime,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'AKTIF',
                                      style: TextStyle(
                                        color: AppColors.textOnAccent,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Atur sendiri Solar PV, Beban Listrik & Baterai untuk presentasi',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.electricLime,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColors.surfaceBorderSubtle),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'ATAU SKENARIO PRESET',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.surfaceBorderSubtle),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...List.generate(service.availableScenarios.length, (idx) {
                final sc = service.availableScenarios[idx];
                final isSelected =
                    !service.isCustomMode && service.scenarioIndex == idx;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.electricLime.withAlpha(20)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.electricLime
                          : AppColors.surfaceBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: StatusBadge(status: sc.status, compact: true),
                    title: Text(
                      sc.scenarioTitle,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    subtitle: Text(
                      'Solar ${sc.solarProduction} kWh • Beban ${sc.energyConsumption} kWh • Bat ${sc.batteryPercentage}%',
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.electricLime,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      service.selectScenario(idx);
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

/// Stylized geometric logo for PANS ENERGI
class _PansBrandLogo extends StatelessWidget {
  const _PansBrandLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF162D4A), Color(0xFF0F1E33)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.electricLime.withAlpha(120),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x3310E599), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: CustomPaint(painter: _PansLogoPainter()),
    );
  }
}

class _PansLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricLime
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.solarGold
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Stylized letter P combined with lightning spark
    final path = Path()
      ..moveTo(w * 0.32, h * 0.22)
      ..lineTo(w * 0.62, h * 0.22)
      ..cubicTo(w * 0.76, h * 0.22, w * 0.76, h * 0.52, w * 0.60, h * 0.52)
      ..lineTo(w * 0.44, h * 0.52)
      ..lineTo(w * 0.44, h * 0.78)
      ..lineTo(w * 0.32, h * 0.78)
      ..close();

    canvas.drawPath(path, paint);

    // Dynamic energy lightning bolt cut/accent
    final boltPath = Path()
      ..moveTo(w * 0.52, h * 0.45)
      ..lineTo(w * 0.68, h * 0.45)
      ..lineTo(w * 0.48, h * 0.75)
      ..lineTo(w * 0.54, h * 0.55)
      ..lineTo(w * 0.44, h * 0.55)
      ..close();

    canvas.drawPath(boltPath, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
