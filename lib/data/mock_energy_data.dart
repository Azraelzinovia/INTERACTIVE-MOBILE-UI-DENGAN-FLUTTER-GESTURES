import 'package:flutter/material.dart';

import '../models/energy_data.dart';
import '../models/energy_recommendation.dart';

/// Hourly telemetry record for analytics and custom charts.
class HourlyTelemetry {
  final int hour; // 0 to 23
  final double solarKwh;
  final double consumptionKwh;

  const HourlyTelemetry({
    required this.hour,
    required this.solarKwh,
    required this.consumptionKwh,
  });

  double get netBalance => solarKwh - consumptionKwh;
  String get hourLabel => '${hour.toString().padLeft(2, '0')}:00';
}

/// Simulated dataset and scenarios for PANS ENERGI.
class MockEnergyData {
  MockEnergyData._();

  // 4 Interactive Telemetry Scenarios for testing and grading evaluation
  static final List<EnergyData> scenarios = [
    // Scenario 0: Default Peak Sun (Surplus)
    EnergyData(
      solarProduction: 5.8,
      energyConsumption: 3.2,
      batteryPercentage: 78,
      batteryCapacityKwh: 10.0,
      scenarioTitle: 'Siang Cerah (Surplus Puncak)',
      timestamp: DateTime.now(),
    ),
    // Scenario 1: Cloudy Afternoon (Balanced)
    EnergyData(
      solarProduction: 3.2,
      energyConsumption: 3.3,
      batteryPercentage: 64,
      batteryCapacityKwh: 10.0,
      scenarioTitle: 'Sore Berawan (Net-Zero Seimbang)',
      timestamp: DateTime.now(),
    ),
    // Scenario 2: Evening Peak (Deficit)
    EnergyData(
      solarProduction: 0.8,
      energyConsumption: 4.6,
      batteryPercentage: 48,
      batteryCapacityKwh: 10.0,
      scenarioTitle: 'Petang Hari (Defisit Terkendali)',
      timestamp: DateTime.now(),
    ),
    // Scenario 3: Depleted Battery (Critical)
    EnergyData(
      solarProduction: 0.0,
      energyConsumption: 3.9,
      batteryPercentage: 19,
      batteryCapacityKwh: 10.0,
      scenarioTitle: 'Malam Badai (Kondisi Kritis)',
      timestamp: DateTime.now(),
    ),
  ];

  // 24-Hour continuous curve for analytical charting
  static const List<HourlyTelemetry> hourlyCurve = [
    HourlyTelemetry(hour: 0, solarKwh: 0.0, consumptionKwh: 1.4),
    HourlyTelemetry(hour: 1, solarKwh: 0.0, consumptionKwh: 1.2),
    HourlyTelemetry(hour: 2, solarKwh: 0.0, consumptionKwh: 1.1),
    HourlyTelemetry(hour: 3, solarKwh: 0.0, consumptionKwh: 1.1),
    HourlyTelemetry(hour: 4, solarKwh: 0.0, consumptionKwh: 1.3),
    HourlyTelemetry(hour: 5, solarKwh: 0.2, consumptionKwh: 1.8),
    HourlyTelemetry(hour: 6, solarKwh: 0.9, consumptionKwh: 2.6),
    HourlyTelemetry(hour: 7, solarKwh: 1.8, consumptionKwh: 3.2),
    HourlyTelemetry(hour: 8, solarKwh: 3.1, consumptionKwh: 2.9),
    HourlyTelemetry(hour: 9, solarKwh: 4.5, consumptionKwh: 2.7),
    HourlyTelemetry(hour: 10, solarKwh: 5.4, consumptionKwh: 3.0),
    HourlyTelemetry(hour: 11, solarKwh: 6.1, consumptionKwh: 3.4),
    HourlyTelemetry(hour: 12, solarKwh: 6.3, consumptionKwh: 3.1),
    HourlyTelemetry(hour: 13, solarKwh: 5.9, consumptionKwh: 2.8),
    HourlyTelemetry(hour: 14, solarKwh: 5.1, consumptionKwh: 3.3),
    HourlyTelemetry(hour: 15, solarKwh: 4.0, consumptionKwh: 3.6),
    HourlyTelemetry(hour: 16, solarKwh: 2.6, consumptionKwh: 3.9),
    HourlyTelemetry(hour: 17, solarKwh: 1.2, consumptionKwh: 4.4),
    HourlyTelemetry(hour: 18, solarKwh: 0.3, consumptionKwh: 4.8),
    HourlyTelemetry(hour: 19, solarKwh: 0.0, consumptionKwh: 4.5),
    HourlyTelemetry(hour: 20, solarKwh: 0.0, consumptionKwh: 3.8),
    HourlyTelemetry(hour: 21, solarKwh: 0.0, consumptionKwh: 3.1),
    HourlyTelemetry(hour: 22, solarKwh: 0.0, consumptionKwh: 2.4),
    HourlyTelemetry(hour: 23, solarKwh: 0.0, consumptionKwh: 1.8),
  ];

  // Smart Recommendations for the energy assistant
  static List<EnergyRecommendation> getDefaultRecommendations() {
    return [
      const EnergyRecommendation(
        id: 'rec_01',
        title: 'Maksimalkan Penggunaan Surya',
        summary: 'Aktifkan mesin cuci, pompa air, atau isi daya kendaraan listrik saat produksi surya melimpah.',
        triggerCondition: 'Surplus surya > 2.0 kWh terdeteksi pada siang hari',
        suggestedAction: 'Jadwalkan perangkat pemanas dan pengisian baterai EV ke mode pengisian otomatis 100% surya.',
        impactEstimated: 'Menghemat ~2.4 kWh listrik grid PLN & mengoptimalkan ROI fotovoltaik.',
        applicableStatus: EnergyStatus.surplus,
        icon: Icons.wb_sunny_rounded,
        priority: 'RECOMMENDED',
        isAccepted: false,
      ),
      const EnergyRecommendation(
        id: 'rec_02',
        title: 'Preservasi Cadangan Baterai',
        summary: 'Pertahankan SOC baterai di atas 70% sebagai persiapan antisipasi puncak konsumsi malam hari.',
        triggerCondition:
            'Baterai mencapai 78% saat produksi surya mulai melandai',
        suggestedAction: 'Arahkan sisa surplus 0.6 kWh secara prioritas ke penyimpanan baterai rumah.',
        impactEstimated:
            'Memastikan cadangan 7.8 kWh siap menopang seluruh beban malam.',
        applicableStatus: EnergyStatus.surplus,
        icon: Icons.battery_charging_full_rounded,
        priority: 'HIGH',
        isAccepted: false,
      ),
      const EnergyRecommendation(
        id: 'rec_03',
        title: 'Reduksi Beban Fleksibel (Peak Shaving)',
        summary: 'Turunkan beban pendingin ruangan (AC) sebesar 1-2°C dan tunda pemakaian oven elektrik.',
        triggerCondition:
            'Defisit energi > 3.0 kWh pada rentang jam 18:00 - 21:00',
        suggestedAction: 'Atur AC ruang tamu ke mode Eco 25°C dan matikan water heater sekunder.',
        impactEstimated: 'Mencegah pengurasan baterai cepat dan menekan tarif listrik puncak.',
        applicableStatus: EnergyStatus.deficit,
        icon: Icons.energy_savings_leaf_rounded,
        priority: 'HIGH',
        isAccepted: false,
      ),
      const EnergyRecommendation(
        id: 'rec_04',
        title: 'Protokol Darurat: Beban Kritis',
        summary: 'Peringatan baterai rendah! Isolasi jalur listrik hanya untuk beban primer essensial.',
        triggerCondition:
            'Level baterai <= 25% bersamaan dengan ketiadaan pasokan surya',
        suggestedAction: 'Putus daya sirkuit sekunder (pemanas, kulkas showcase, lampu hias). Pertahankan pencahayaan utama & router.',
        impactEstimated:
            'Memperpanjang daya tahan cadangan listrik kritis hingga 4.5 jam.',
        applicableStatus: EnergyStatus.critical,
        icon: Icons.shield_rounded,
        priority: 'URGENT',
        isAccepted: false,
      ),
      const EnergyRecommendation(
        id: 'rec_05',
        title: 'Pertahankan Operasi Net-Zero',
        summary: 'Keseimbangan sistem optimal. Terus pantau fluktuasi konsumsi beban rumah.',
        triggerCondition:
            'Selisih energi stabil di rentang net-zero (-0.5 s/d +0.5 kWh)',
        suggestedAction: 'Hindari penambahan beban mendadak dan biarkan sistem regulasi inverter bekerja dinamis.',
        impactEstimated:
            'Efisiensi sirkuit 98.4% tanpa penarikan daya berbayar dari grid.',
        applicableStatus: EnergyStatus.balanced,
        icon: Icons.published_with_changes_rounded,
        priority: 'MODERATE',
        isAccepted: false,
      ),
    ];
  }
}
