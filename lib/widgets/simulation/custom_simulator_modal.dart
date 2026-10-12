import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/energy_calculator.dart';
import '../../models/energy_data.dart';
import '../../services/energy_service.dart';
import '../common/status_badge.dart';

/// Modal bottom sheet that enables users/presenters to manually configure
/// arbitrary solar generation, consumption load, and battery storage levels.
/// Provides live reactive feedback and presentation demo presets.
class CustomSimulatorModal extends StatefulWidget {
  final EnergyData? initialData;

  const CustomSimulatorModal({super.key, this.initialData});

  /// Convenient helper to open the simulator modal bottom sheet
  static Future<void> show(BuildContext context) {
    final currentData = EnergyScope.of(context).currentData;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CustomSimulatorModal(initialData: currentData),
    );
  }

  @override
  State<CustomSimulatorModal> createState() => _CustomSimulatorModalState();
}

class _CustomSimulatorModalState extends State<CustomSimulatorModal> {
  late double _solarProduction;
  late double _energyConsumption;
  late int _batteryPercentage;
  bool _liveSync = true;
  String _scenarioTitle = 'Simulasi Kustom (Presentasi)';

  @override
  void initState() {
    super.initState();
    final current = widget.initialData;
    _solarProduction = current?.solarProduction ?? 5.8;
    _energyConsumption = current?.energyConsumption ?? 3.2;
    _batteryPercentage = current?.batteryPercentage ?? 78;
  }

  void _syncIfLive(EnergyService service) {
    if (_liveSync) {
      service.setCustomData(
        solarProduction: _solarProduction,
        energyConsumption: _energyConsumption,
        batteryPercentage: _batteryPercentage,
        scenarioTitle: _scenarioTitle,
      );
    }
  }

  void _applyPreset({
    required String title,
    required double solar,
    required double consumption,
    required int battery,
    required EnergyService service,
  }) {
    setState(() {
      _scenarioTitle = title;
      _solarProduction = solar;
      _energyConsumption = consumption;
      _batteryPercentage = battery;
    });
    service.setCustomData(
      solarProduction: _solarProduction,
      energyConsumption: _energyConsumption,
      batteryPercentage: _batteryPercentage,
      scenarioTitle: _scenarioTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = EnergyScope.of(context);

    // Compute preview data instantaneously
    final previewData = EnergyData(
      solarProduction: _solarProduction,
      energyConsumption: _energyConsumption,
      batteryPercentage: _batteryPercentage,
      scenarioTitle: _scenarioTitle,
      timestamp: DateTime.now(),
    );
    final balance = previewData.energyBalance;
    final status = previewData.status;

    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.88,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: ListView(
          children: [
              // Handle bar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withAlpha(90),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Title row with Live Sync switch & Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: AppColors.electricLime,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Studio Simulasi Kustom',
                              style: AppTextStyles.titleLarge,
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Atur kondisi daya sesuka Anda untuk demonstrasi presentasi',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Live Sync Toggle Banner
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.sync_rounded,
                          color: AppColors.electricLime,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Sync Langsung ke Dashboard',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _liveSync,
                      activeThumbColor: AppColors.electricLime,
                      onChanged: (val) {
                        setState(() => _liveSync = val);
                        if (val) _syncIfLive(service);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Section: Preset Cepat untuk Presentasi
              const Text(
                '⚡ Preset Cepat Presentasi (1-Klik):',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _PresetChip(
                      label: '☀️ Surplus Ekstrem',
                      accentColor: AppColors.solarGold,
                      onTap: () => _applyPreset(
                        title: 'Demo: Surplus Ekstrem',
                        solar: 8.5,
                        consumption: 2.2,
                        battery: 88,
                        service: service,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PresetChip(
                      label: '⚖️ Net-Zero Seimbang',
                      accentColor: AppColors.statusBalanced,
                      onTap: () => _applyPreset(
                        title: 'Demo: Net-Zero Seimbang',
                        solar: 3.5,
                        consumption: 3.4,
                        battery: 65,
                        service: service,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PresetChip(
                      label: '⚡ Defisit Beban Tinggi',
                      accentColor: AppColors.consumptionOrange,
                      onTap: () => _applyPreset(
                        title: 'Demo: Defisit Malam Hari',
                        solar: 0.8,
                        consumption: 6.0,
                        battery: 52,
                        service: service,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PresetChip(
                      label: '🚨 Baterai Kritis Darurat',
                      accentColor: AppColors.alertRed,
                      onTap: () => _applyPreset(
                        title: 'Demo: Darurat Baterai Drop',
                        solar: 0.0,
                        consumption: 4.5,
                        battery: 15,
                        service: service,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PresetChip(
                      label: '🔋 Penuh & Mandiri',
                      accentColor: AppColors.batteryCyan,
                      onTap: () => _applyPreset(
                        title: 'Demo: ESS Mandiri Penuh',
                        solar: 6.0,
                        consumption: 1.5,
                        battery: 99,
                        service: service,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Control 1: Solar Production
              _SliderControlCard(
                title: 'Produksi Surya (Solar PV)',
                valueLabel: '${_solarProduction.toStringAsFixed(1)} kW',
                value: _solarProduction,
                min: 0.0,
                max: 10.0,
                divisions: 100,
                accentColor: AppColors.solarGold,
                icon: Icons.wb_sunny_rounded,
                subtext: 'Daya dari panel fotovoltaik',
                onChanged: (val) {
                  setState(() => _solarProduction = val);
                  _syncIfLive(service);
                },
                onStep: (delta) {
                  setState(() {
                    _solarProduction =
                        (_solarProduction + delta).clamp(0.0, 10.0);
                  });
                  _syncIfLive(service);
                },
              ),

              const SizedBox(height: 14),

              // Control 2: Household Consumption
              _SliderControlCard(
                title: 'Beban Konsumsi Listrik',
                valueLabel: '${_energyConsumption.toStringAsFixed(1)} kW',
                value: _energyConsumption,
                min: 0.0,
                max: 10.0,
                divisions: 100,
                accentColor: AppColors.consumptionOrange,
                icon: Icons.power_rounded,
                subtext: 'Pemakaian alat listrik rumah tangga',
                onChanged: (val) {
                  setState(() => _energyConsumption = val);
                  _syncIfLive(service);
                },
                onStep: (delta) {
                  setState(() {
                    _energyConsumption =
                        (_energyConsumption + delta).clamp(0.0, 10.0);
                  });
                  _syncIfLive(service);
                },
              ),

              const SizedBox(height: 14),

              // Control 3: Battery Storage Level
              _SliderControlCard(
                title: 'Kapasitas Baterai ESS',
                valueLabel:
                    '$_batteryPercentage% (${((_batteryPercentage / 100.0) * 10.0).toStringAsFixed(1)} kWh)',
                value: _batteryPercentage.toDouble(),
                min: 0.0,
                max: 100.0,
                divisions: 100,
                accentColor: _batteryPercentage <= 25
                    ? AppColors.alertRed
                    : AppColors.batteryCyan,
                icon: _batteryPercentage <= 25
                    ? Icons.battery_alert_rounded
                    : Icons.battery_charging_full_rounded,
                subtext: _batteryPercentage <= 25
                    ? '⚠️ Peringatan: Level di bawah batas kritis (<= 25%)'
                    : 'Cadangan daya penyimpanan aktif',
                onChanged: (val) {
                  setState(() => _batteryPercentage = val.round());
                  _syncIfLive(service);
                },
                onStep: (delta) {
                  setState(() {
                    _batteryPercentage =
                        (_batteryPercentage + delta.round()).clamp(0, 100);
                  });
                  _syncIfLive(service);
                },
              ),

              const SizedBox(height: 18),

              // Live Status & Physics Flow Preview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: status.color.withAlpha(120),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: status.color.withAlpha(20),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'HASIL STATUS REAL-TIME',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        StatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          EnergyCalculator.formatBalance(balance),
                          style: TextStyle(
                            color: balance >= 0
                                ? AppColors.electricLime
                                : AppColors.consumptionOrange,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          balance >= 0 ? '(Surplus Daya)' : '(Defisit Daya)',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getFlowExplanation(status, balance, _batteryPercentage),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Apply & Reset Buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricLime,
                        foregroundColor: AppColors.textOnAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text(
                        'Terapkan ke Sistem',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        service.setCustomData(
                          solarProduction: _solarProduction,
                          energyConsumption: _energyConsumption,
                          batteryPercentage: _batteryPercentage,
                          scenarioTitle: _scenarioTitle,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Simulasi Kustom Aktif • Solar ${_solarProduction.toStringAsFixed(1)} kW | Beban ${_energyConsumption.toStringAsFixed(1)} kW | Bat $_batteryPercentage%',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.surfaceBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        service.resetToPreset(0);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Reset Preset',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }

  String _getFlowExplanation(
    EnergyStatus status,
    double balance,
    int batterySoc,
  ) {
    switch (status) {
      case EnergyStatus.surplus:
        return '⚡ Partikel surya mengalir deras dari Solar PV ke Inverter, menyuplai seluruh beban rumah, dan kelebihan daya (+${balance.toStringAsFixed(1)} kW) mengalir mengisi Baterai ESS.';
      case EnergyStatus.balanced:
        return '⚖️ Sistem beroperasi seimbang (Net-Zero). Produksi surya tepat mencukupi konsumsi tanpa menarik atau menguras baterai.';
      case EnergyStatus.deficit:
        return '🔋 Produksi surya tidak mencukupi. Baterai ESS aktif menyuplai defisit (${balance.abs().toStringAsFixed(1)} kW) ke inverter menuju rumah tangga.';
      case EnergyStatus.critical:
        return '🚨 Baterai kritis ($batterySoc%) dan beban listrik defisit! Node baterai menyala merah dan sistem merekomendasikan isolasi beban vital segera.';
    }
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: accentColor.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withAlpha(120), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accentColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SliderControlCard extends StatelessWidget {
  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color accentColor;
  final IconData icon;
  final String subtext;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onStep;

  const _SliderControlCard({
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.accentColor,
    required this.icon,
    required this.subtext,
    required this.onChanged,
    required this.onStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: accentColor, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  valueLabel,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: AppColors.textSecondary,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onStep(max <= 10.0 ? -0.5 : -5.0),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: accentColor,
                    inactiveTrackColor: AppColors.surfaceBorder,
                    thumbColor: accentColor,
                    overlayColor: accentColor.withAlpha(40),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: value.clamp(min, max),
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: onChanged,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: AppColors.textSecondary,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onStep(max <= 10.0 ? 0.5 : 5.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
