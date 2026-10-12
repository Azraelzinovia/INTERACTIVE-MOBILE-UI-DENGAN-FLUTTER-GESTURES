import 'package:flutter/material.dart';

import '../data/mock_energy_data.dart';
import '../models/energy_data.dart';
import '../models/energy_recommendation.dart';

/// Central state coordinator for PANS ENERGI.
/// Extends ChangeNotifier to synchronize state between Dashboard,
/// Analytics, Recommendations, and gesture interactions.
class EnergyService extends ChangeNotifier {
  // Scenario index (0 = Surplus, 1 = Balanced, 2 = Deficit, 3 = Critical)
  int _scenarioIndex = 0;

  // Custom simulation state for live presentations & demonstrations
  EnergyData? _customEnergyData;
  bool _isCustomMode = false;

  // Active list of recommendations
  late List<EnergyRecommendation> _recommendations;

  // Gesture 2: Scale/Pinch State
  double _currentScale = 1.0;
  static const double minScale = 0.8;
  static const double maxScale = 1.8;

  // Gesture 3: Horizontal Swipe Carousel Index
  int _carouselIndex = 0;

  EnergyService() {
    _recommendations = MockEnergyData.getDefaultRecommendations();
  }

  // --- Getters ---
  int get scenarioIndex => _scenarioIndex;
  bool get isCustomMode => _isCustomMode;
  List<EnergyData> get availableScenarios => MockEnergyData.scenarios;
  EnergyData get currentData => _isCustomMode && _customEnergyData != null
      ? _customEnergyData!
      : MockEnergyData.scenarios[_scenarioIndex];
  List<EnergyRecommendation> get recommendations =>
      List.unmodifiable(_recommendations);

  double get currentScale => _currentScale;
  int get carouselIndex => _carouselIndex;

  // Filter recommendations applicable to current status or general
  List<EnergyRecommendation> get activeScenarioRecommendations {
    final status = currentData.status;
    final filtered = _recommendations
        .where((r) => r.applicableStatus == status)
        .toList();
    if (filtered.isEmpty) {
      return _recommendations;
    }
    return filtered;
  }

  int get acceptedCount => _recommendations.where((r) => r.isAccepted).length;

  // --- Scenario Selection ---
  void selectScenario(int index) {
    if (index >= 0 && index < MockEnergyData.scenarios.length) {
      _isCustomMode = false;
      _customEnergyData = null;
      _scenarioIndex = index;
      _carouselIndex = 0; // reset carousel on scenario change
      notifyListeners();
    }
  }

  /// Sets custom live simulation parameters for presenter live demonstrations
  void setCustomData({
    required double solarProduction,
    required double energyConsumption,
    required int batteryPercentage,
    String scenarioTitle = 'Kustom (Presentasi Live)',
    double batteryCapacityKwh = 10.0,
  }) {
    _isCustomMode = true;
    _customEnergyData = EnergyData(
      solarProduction: double.parse(solarProduction.toStringAsFixed(1)),
      energyConsumption: double.parse(energyConsumption.toStringAsFixed(1)),
      batteryPercentage: batteryPercentage.clamp(0, 100),
      batteryCapacityKwh: batteryCapacityKwh,
      scenarioTitle: scenarioTitle,
      timestamp: DateTime.now(),
    );
    _carouselIndex = 0;
    notifyListeners();
  }

  /// Restores to preset scenario mode
  void resetToPreset([int? index]) {
    _isCustomMode = false;
    _customEnergyData = null;
    if (index != null &&
        index >= 0 &&
        index < MockEnergyData.scenarios.length) {
      _scenarioIndex = index;
    }
    _carouselIndex = 0;
    notifyListeners();
  }

  // --- Gesture 1: Double Tap Action ---
  /// Toggles recommendation acceptance state
  bool toggleRecommendation(String id) {
    final index = _recommendations.indexWhere((r) => r.id == id);
    if (index != -1) {
      final current = _recommendations[index];
      final newStatus = !current.isAccepted;
      _recommendations[index] = current.copyWith(isAccepted: newStatus);
      notifyListeners();
      return newStatus;
    }
    return false;
  }

  // --- Gesture 2: Pinch / Scale Management ---
  void setScale(double newScale) {
    final clamped = newScale.clamp(minScale, maxScale);
    if ((_currentScale - clamped).abs() > 0.001) {
      _currentScale = clamped;
      notifyListeners();
    }
  }

  void resetScale() {
    _currentScale = 1.0;
    notifyListeners();
  }

  // --- Gesture 3: Swipe / Carousel Navigation ---
  void nextRecommendation(int maxItems) {
    if (maxItems <= 0) return;
    _carouselIndex = (_carouselIndex + 1) % maxItems;
    notifyListeners();
  }

  void prevRecommendation(int maxItems) {
    if (maxItems <= 0) return;
    _carouselIndex = (_carouselIndex - 1 + maxItems) % maxItems;
    notifyListeners();
  }

  void setCarouselIndex(int index, int maxItems) {
    if (maxItems <= 0) return;
    _carouselIndex = index.clamp(0, maxItems - 1);
    notifyListeners();
  }
}

/// InheritedNotifier providing EnergyService down the widget tree.
class EnergyScope extends InheritedNotifier<EnergyService> {
  const EnergyScope({
    super.key,
    required EnergyService service,
    required super.child,
  }) : super(notifier: service);

  static EnergyService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<EnergyScope>();
    assert(scope != null, 'No EnergyScope found in context');
    return scope!.notifier!;
  }
}
