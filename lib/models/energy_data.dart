import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Enum representing the 4 categorical operational states of the energy system.
enum EnergyStatus { surplus, balanced, deficit, critical }

extension EnergyStatusX on EnergyStatus {
  String get displayName {
    switch (this) {
      case EnergyStatus.surplus:
        return 'SURPLUS';
      case EnergyStatus.balanced:
        return 'BALANCED';
      case EnergyStatus.deficit:
        return 'DEFICIT';
      case EnergyStatus.critical:
        return 'CRITICAL';
    }
  }

  String get shortDescription {
    switch (this) {
      case EnergyStatus.surplus:
        return 'Produksi surya melimpah. Energi bersih mencukupi seluruh beban dan dapat disimpan.';
      case EnergyStatus.balanced:
        return 'Produksi dan konsumsi seimbang. Sistem beroperasi stabil mendekati net-zero.';
      case EnergyStatus.deficit:
        return 'Konsumsi melebihi produksi. Daya disuplai cadangan baterai atau grid cadangan.';
      case EnergyStatus.critical:
        return 'Peringatan! Baterai rendah di bawah 25% dan produksi surya tidak mencukupi.';
    }
  }

  Color get color {
    switch (this) {
      case EnergyStatus.surplus:
        return AppColors.statusSurplus;
      case EnergyStatus.balanced:
        return AppColors.statusBalanced;
      case EnergyStatus.deficit:
        return AppColors.statusDeficit;
      case EnergyStatus.critical:
        return AppColors.statusCritical;
    }
  }

  IconData get icon {
    switch (this) {
      case EnergyStatus.surplus:
        return Icons.solar_power_rounded;
      case EnergyStatus.balanced:
        return Icons.balance_rounded;
      case EnergyStatus.deficit:
        return Icons.trending_down_rounded;
      case EnergyStatus.critical:
        return Icons.warning_amber_rounded;
    }
  }
}

/// Represents an instantaneous snapshot of the renewable energy system telemetry.
class EnergyData {
  final double solarProduction; // in kWh
  final double energyConsumption; // in kWh
  final int batteryPercentage; // 0 - 100 %
  final double batteryCapacityKwh; // total battery capacity e.g. 10.0 kWh
  final String scenarioTitle; // human-readable scenario identifier
  final DateTime timestamp;

  const EnergyData({
    required this.solarProduction,
    required this.energyConsumption,
    required this.batteryPercentage,
    this.batteryCapacityKwh = 10.0,
    required this.scenarioTitle,
    required this.timestamp,
  });

  /// Mathematical energy balance: Solar Production - Energy Consumption
  double get energyBalance => solarProduction - energyConsumption;

  /// Categorical energy status based on balance and battery health.
  EnergyStatus get status {
    // Critical condition: Battery <= 25% AND deficit (balance < 0)
    if (batteryPercentage <= 25 && energyBalance < 0) {
      return EnergyStatus.critical;
    }
    if (energyBalance > 0.5) {
      return EnergyStatus.surplus;
    }
    if (energyBalance < -0.5) {
      return EnergyStatus.deficit;
    }
    return EnergyStatus.balanced;
  }

  /// Estimated current stored battery energy in kWh
  double get currentBatteryKwh =>
      (batteryPercentage / 100.0) * batteryCapacityKwh;

  /// Clean energy coverage percentage (0 to 100%+)
  double get selfSufficiencyRatio {
    if (energyConsumption <= 0) return 100.0;
    final ratio = (solarProduction / energyConsumption) * 100.0;
    return ratio.clamp(0.0, 200.0);
  }

  /// Simulated CO2 emissions avoided today (0.82 kg CO2 per kWh solar)
  double get co2SavedKg => solarProduction * 0.82;

  EnergyData copyWith({
    double? solarProduction,
    double? energyConsumption,
    int? batteryPercentage,
    double? batteryCapacityKwh,
    String? scenarioTitle,
    DateTime? timestamp,
  }) {
    return EnergyData(
      solarProduction: solarProduction ?? this.solarProduction,
      energyConsumption: energyConsumption ?? this.energyConsumption,
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      batteryCapacityKwh: batteryCapacityKwh ?? this.batteryCapacityKwh,
      scenarioTitle: scenarioTitle ?? this.scenarioTitle,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
