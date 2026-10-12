import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'about_screen.dart';
import 'analytics_screen.dart';
import 'dashboard_screen.dart';
import 'recommendations_screen.dart';

/// Main navigation container wrapping the 4 primary tabs:
/// Dashboard, Analytics, Recommendations, and About.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    AnalyticsScreen(),
    RecommendationsScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.surfaceBorder, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.electricLime.withAlpha(45),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics_rounded),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.checklist_rtl_rounded),
              selectedIcon: Icon(Icons.checklist_rounded),
              label: 'Rekomendasi',
            ),
            NavigationDestination(
              icon: Icon(Icons.eco_outlined),
              selectedIcon: Icon(Icons.eco_rounded),
              label: 'Tentang',
            ),
          ],
        ),
      ),
    );
  }
}
