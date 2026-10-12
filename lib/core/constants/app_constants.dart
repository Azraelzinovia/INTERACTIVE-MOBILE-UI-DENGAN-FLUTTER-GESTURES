/// Application constants for PANS ENERGI
class AppConstants {
  AppConstants._();

  static const String appName = 'PANS ENERGI';
  static const String appTagline = 'Intelligence for Every Watt.';
  static const String appVersion = '1.0.0 (Release)';
  static const String academicContext = 'Tugas Pemrograman Mobile — NIM Genap';

  // Gesture specifications
  static const String gestureDoubleTapTitle = 'Gesture 1: Double Tap';
  static const String gestureDoubleTapDesc =
      'Ketuk dua kali kartu rekomendasi untuk menerima (Accept) atau membatalkan (Pending) rekomendasi efisiensi energi.';

  static const String gestureScaleTitle = 'Gesture 2: Scale / Pinch';
  static const String gestureScaleDesc =
      'Gunakan pinch 2 jari untuk memperbesar (zoom in hingga 1.8x) atau memperkecil (zoom out hingga 0.8x) visualisasi sistem aliran energi.';

  static const String gestureSwipeTitle = 'Gesture 3: Swipe / Horizontal Drag';
  static const String gestureSwipeDesc =
      'Geser ke kiri atau kanan pada area Smart Recommendations Carousel untuk beralih antar kartu rekomendasi dinamis.';

  // Energy Calculation Thresholds
  static const double surplusThresholdKwh = 0.5;
  static const double deficitThresholdKwh = -0.5;
  static const int criticalBatteryThresholdPercent = 25;

  // SDG Highlights
  static const String sdg7Title = 'SDG 7: Affordable and Clean Energy';
  static const String sdg7Desc =
      'Mendukung pemanfaatan energi terbarukan mandiri (solar photovoltaic) serta optimalisasi konsumsi listrik rumah tangga secara efisien dan berkelanjutan.';

  static const String sdg12Title =
      'SDG 12: Responsible Consumption and Production';
  static const String sdg12Desc =
      'Mendorong peralihan beban listrik fleksibel ke jam produksi surya puncak untuk meminimalkan ketergantungan pada jaringan berbahan bakar fosil.';

  // Simulation Note
  static const String simulationNotice =
      'Aplikasi ini beroperasi menggunakan simulasi data telemetri energi lokal yang akurat dan konsisten untuk kebutuhan evaluasi akademik & demonstrasi UI/UX.';
}
