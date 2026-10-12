import 'package:tugas1/models/energy_data.dart';

/// Calculation and analytical utility methods for PANS ENERGI.
class EnergyCalculator {
  EnergyCalculator._();

  /// Calculates net balance: Solar Production - Consumption
  static double calculateBalance(double solarKwh, double consumptionKwh) {
    return double.parse((solarKwh - consumptionKwh).toStringAsFixed(2));
  }

  /// Formats kWh with +/- sign and 1 decimal place
  static String formatBalance(double balance) {
    final prefix = balance > 0 ? '+' : '';
    return '$prefix${balance.toStringAsFixed(1)} kWh';
  }

  /// Formats value with 1 decimal place and unit
  static String formatKwh(double value) {
    return '${value.toStringAsFixed(1)} kWh';
  }

  /// Generates dynamic contextual insight based strictly on the current energy telemetry.
  static String generateInsight(EnergyData data) {
    final balance = data.energyBalance;
    final status = data.status;

    switch (status) {
      case EnergyStatus.surplus:
        return 'Produksi energi surya saat ini (${data.solarProduction.toStringAsFixed(1)} kWh) melampaui konsumsi (${data.energyConsumption.toStringAsFixed(1)} kWh). Terdapat surplus ${balance.toStringAsFixed(1)} kWh yang dialokasikan untuk mengisi baterai (${data.batteryPercentage}%) dan siap mendukung beban fleksibel seperti EV charging atau water heater.';

      case EnergyStatus.balanced:
        return 'Sistem energi beroperasi dalam kondisi mendekati net-zero. Produksi surya (${data.solarProduction.toStringAsFixed(1)} kWh) seimbang dengan beban aktif (${data.energyConsumption.toStringAsFixed(1)} kWh). Pertahankan pola konsumsi saat ini untuk menjaga kestabilan cadangan baterai (${data.batteryPercentage}%).';

      case EnergyStatus.deficit:
        return 'Konsumsi listrik (${data.energyConsumption.toStringAsFixed(1)} kWh) melebihi kapasitas surya (${data.solarProduction.toStringAsFixed(1)} kWh), dengan defisit ${balance.abs().toStringAsFixed(1)} kWh. Baterai masih menyuplai cadangan (${data.batteryPercentage}%). Direkomendasikan mereduksi beban sekunder agar daya cadangan bertahan hingga malam.';

      case EnergyStatus.critical:
        return 'PERINGATAN SISTEM: Cadangan baterai berada pada level kritis (${data.batteryPercentage}%) dengan defisit daya ${balance.abs().toStringAsFixed(1)} kWh. Segera aktifkan protokol pemadaman beban non-esensial untuk menjaga pasokan peralatan vital rumah tangga.';
    }
  }
}
