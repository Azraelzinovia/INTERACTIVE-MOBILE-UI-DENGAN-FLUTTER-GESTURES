import 'package:flutter/material.dart';

/// Design tokens and color palette for PANS ENERGI.
/// Follows dark-first aesthetic with midnight navy background,
/// electric lime / energy green accents, and measured gradients.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Backgrounds & Surface
  static const Color background = Color(0xFF0A0F1D);
  static const Color surface = Color(0xFF111A2E);
  static const Color surfaceElevated = Color(0xFF18233C);
  static const Color surfaceBorder = Color(0xFF223252);
  static const Color surfaceBorderSubtle = Color(0xFF1E293B);

  // Primary Energy Accents
  static const Color electricLime = Color(0xFF10E599);
  static const Color electricLimeGlow = Color(0x3310E599);
  static const Color energyGreen = Color(0xFF22C55E);
  static const Color solarGold = Color(0xFFFBBF24);
  static const Color solarGoldGlow = Color(0x33FBBF24);
  static const Color batteryCyan = Color(0xFF06B6D4);
  static const Color consumptionOrange = Color(0xFFFB923C);
  static const Color alertRed = Color(0xFFF43F5E);
  static const Color alertRedGlow = Color(0x33F43F5E);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textOnAccent = Color(0xFF0A0F1D);

  // Status-specific Colors
  static const Color statusSurplus = Color(0xFF10E599);
  static const Color statusBalanced = Color(0xFF38BDF8);
  static const Color statusDeficit = Color(0xFFFB923C);
  static const Color statusCritical = Color(0xFFF43F5E);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF142442), Color(0xFF0F1B33), Color(0xFF0C1427)],
  );

  static const LinearGradient surplusGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10E599), Color(0xFF059669)],
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x1A10E599), Colors.transparent],
  );

  static const LinearGradient flowLineGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFF10E599), Color(0xFF06B6D4)],
  );
}
