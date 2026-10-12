import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas1/app.dart';
import 'package:tugas1/core/utils/energy_calculator.dart';
import 'package:tugas1/models/energy_data.dart';
import 'package:tugas1/services/energy_service.dart';
import 'package:tugas1/widgets/dashboard/energy_flow_visualization.dart';
import 'package:tugas1/widgets/recommendations/recommendation_card.dart';

void main() {
  group('PANS ENERGI Business Logic Tests', () {
    test('Energy calculation and status logic', () {
      final surplusData = EnergyData(
        solarProduction: 5.8,
        energyConsumption: 3.2,
        batteryPercentage: 78,
        scenarioTitle: 'Surplus Test',
        timestamp: DateTime.now(),
      );

      expect(surplusData.energyBalance, closeTo(2.6, 0.01));
      expect(surplusData.status, equals(EnergyStatus.surplus));

      final criticalData = EnergyData(
        solarProduction: 0.0,
        energyConsumption: 3.9,
        batteryPercentage: 19,
        scenarioTitle: 'Critical Test',
        timestamp: DateTime.now(),
      );

      expect(criticalData.energyBalance, closeTo(-3.9, 0.01));
      expect(criticalData.status, equals(EnergyStatus.critical));

      final insight = EnergyCalculator.generateInsight(surplusData);
      expect(insight.contains('surplus 2.6 kWh'), isTrue);
    });
  });

  group('PANS ENERGI Widget & Gesture Tests', () {
    testWidgets('App renders dashboard, hero status, and metrics correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const PansEnergiApp());
      await tester.pump(const Duration(milliseconds: 300));

      // Verify Header & Branding
      expect(find.text('PANS ENERGI'), findsOneWidget);
      expect(find.text('NET ENERGY BALANCE'), findsOneWidget);
      expect(find.text('+2.6 kWh'), findsOneWidget);
      expect(find.text('SURPLUS'), findsWidgets);

      // Verify Metrics
      expect(find.text('Produksi Surya'), findsWidgets);
      expect(find.text('Beban Rumah'), findsWidgets);
      expect(find.text('Baterai'), findsOneWidget);
    });

    testWidgets(
      'Gesture 1: Double Tap toggles recommendation acceptance state',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PansEnergiApp());
        await tester.pump(const Duration(milliseconds: 300));

        // Find the Recommendation Pending badge
        expect(find.text('RECOMMENDATION PENDING'), findsOneWidget);
        expect(find.text('RECOMMENDATION ACCEPTED'), findsNothing);

        // Scroll until recommendation card is visible
        final cardFinder = find.byType(RecommendationCard).first;
        await tester.ensureVisible(cardFinder);
        await tester.pump(const Duration(milliseconds: 300));

        // Double tap on the recommendation card
        await tester.tap(cardFinder);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tap(cardFinder);
        await tester.pump(const Duration(milliseconds: 400));

        // Verify state changed to ACCEPTED
        expect(find.text('RECOMMENDATION ACCEPTED'), findsOneWidget);

        // Wait for SnackBar to dismiss before second double-tap
        await tester.pump(const Duration(milliseconds: 2000));

        // Double tap again to toggle back
        await tester.tap(cardFinder);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tap(cardFinder);
        await tester.pump(const Duration(milliseconds: 400));

        // Verify toggled back to PENDING
        expect(find.text('RECOMMENDATION PENDING'), findsOneWidget);
      },
    );

    testWidgets(
      'Gesture 2: Scale/Pinch adjusts energy flow canvas zoom level and resets',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PansEnergiApp());
        await tester.pump(const Duration(milliseconds: 300));

        // Locate scale indicator
        expect(find.text('1.00x'), findsOneWidget);

        final flowFinder = find.byType(EnergyFlowVisualization);
        await tester.ensureVisible(flowFinder);
        await tester.pump(const Duration(milliseconds: 300));

        // Test scale update via EnergyScope
        final context = tester.element(flowFinder);
        EnergyScope.of(context).setScale(1.35);
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('1.35x'), findsOneWidget);
        expect(find.text('Reset'), findsOneWidget);

        // Tap reset button
        await tester.tap(find.text('Reset'));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('1.00x'), findsOneWidget);
      },
    );

    testWidgets(
      'Gesture 3: Swipe / Horizontal Drag switches carousel recommendation card',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PansEnergiApp());
        await tester.pump(const Duration(milliseconds: 300));

        // Scroll down to carousel
        final cardFinder = find.byType(RecommendationCard).first;
        await tester.ensureVisible(cardFinder);
        await tester.pump(const Duration(milliseconds: 300));

        // Initial position is 1 / 2 for Surplus scenario
        expect(find.text('1 / 2'), findsOneWidget);

        // Perform swipe left (fling with negative dx and velocity)
        await tester.fling(cardFinder, const Offset(-300, 0), 1000, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 400));

        // Next item 2 / 2 should now be visible
        expect(find.text('2 / 2'), findsOneWidget);

        // Ensure visible and swipe right (positive dx) to go back
        final updatedCardFinder = find.byType(RecommendationCard).first;
        await tester.ensureVisible(updatedCardFinder);
        await tester.fling(updatedCardFinder, const Offset(300, 0), 1000, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 400));

        // Toggled back to 1 / 2
        expect(find.text('1 / 2'), findsOneWidget);
      },
    );

    testWidgets('Navigation switches across tabs cleanly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const PansEnergiApp());
      await tester.pump(const Duration(milliseconds: 300));

      // Tap on Analytics tab
      await tester.tap(find.text('Analytics'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Energy Analytics'), findsOneWidget);
      expect(find.text('Profil Pembangkitan & Beban'), findsOneWidget);

      // Tap on Rekomendasi tab
      await tester.tap(find.text('Rekomendasi'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Rekomendasi Cerdas'), findsOneWidget);
      expect(find.text('Petunjuk Gesture (Double Tap)'), findsOneWidget);

      // Tap on Tentang tab
      await tester.tap(find.text('Tentang'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Tentang PANS ENERGI'), findsOneWidget);
      expect(
        find.text('Panduan Pengujian Gesture (NIM Genap)'),
        findsOneWidget,
      );
    });

    testWidgets('Custom Simulator Modal opens and applies custom presenter parameters', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const PansEnergiApp());
      await tester.pump(const Duration(milliseconds: 300));

      // Tap on the Simulasi Kustom FAB
      expect(find.text('Simulasi Kustom'), findsOneWidget);
      await tester.tap(find.text('Simulasi Kustom'));
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify Studio Simulasi Kustom modal appears
      expect(find.text('Studio Simulasi Kustom'), findsOneWidget);
      expect(find.text('Produksi Surya (Solar PV)'), findsOneWidget);
      expect(find.text('Beban Konsumsi Listrik'), findsOneWidget);
      expect(find.text('Kapasitas Baterai ESS'), findsOneWidget);

      // Tap Preset Chip "☀️ Surplus Ekstrem"
      final presetFinder = find.text('☀️ Surplus Ekstrem');
      expect(presetFinder, findsOneWidget);
      await tester.tap(presetFinder);
      await tester.pump(const Duration(milliseconds: 300));

      // Tap "Terapkan ke Sistem"
      final applyFinder = find.text('Terapkan ke Sistem');
      expect(applyFinder, findsOneWidget);
      await tester.tap(applyFinder);
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Modal closed, custom mode banner is now active on dashboard
      expect(find.text('Mode Simulasi Kustom Aktif'), findsOneWidget);
      expect(find.text('+6.3 kWh'), findsOneWidget); // 8.5 - 2.2 = +6.3 kWh
    });
  });
}
