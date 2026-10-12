import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'services/energy_service.dart';

/// Top-level application widget for PANS ENERGI.
/// Provides EnergyScope and configures dark theme.
class PansEnergiApp extends StatefulWidget {
  const PansEnergiApp({super.key});

  @override
  State<PansEnergiApp> createState() => _PansEnergiAppState();
}

class _PansEnergiAppState extends State<PansEnergiApp> {
  late final EnergyService _energyService;

  @override
  void initState() {
    super.initState();
    _energyService = EnergyService();
  }

  @override
  void dispose() {
    _energyService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnergyScope(
      service: _energyService,
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
