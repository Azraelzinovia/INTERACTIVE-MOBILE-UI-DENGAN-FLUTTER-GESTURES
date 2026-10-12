import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// About screen showcasing PANS ENERGI brand, SDG 7/12 contributions,
/// simulation transparency, and the academic grading gesture testing guide.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tentang PANS ENERGI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Brand Banner
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF142642), Color(0xFF0F1B30)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.electricLime.withAlpha(100),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3310E599),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.electricLime.withAlpha(25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricLime.withAlpha(120),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.electricLime,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AppConstants.appTagline,
                    style: TextStyle(
                      color: AppColors.electricLime,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: const Text(
                      'Versi 1.0.0 • Mobile Programming',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Academic Context & Gesture Verification Guide (For Evaluator/Lecturer)
            _GradingGestureGuideCard(),

            const SizedBox(height: 20),

            // SDG 7 & SDG 12 Alignment Cards
            _SdgAlignmentCard(
              title: AppConstants.sdg7Title,
              desc: AppConstants.sdg7Desc,
              badgeColor: const Color(0xFFFACC15),
              icon: Icons.solar_power_rounded,
            ),

            const SizedBox(height: 12),

            _SdgAlignmentCard(
              title: AppConstants.sdg12Title,
              desc: AppConstants.sdg12Desc,
              badgeColor: const Color(0xFFFB923C),
              icon: Icons.recycling_rounded,
            ),

            const SizedBox(height: 20),

            // Simulation Data Integrity Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.batteryCyan,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Integritas Data & Transparansi Simulasi',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppConstants.simulationNotice,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Academic grading reference card detailing the 3 mandatory gestures
class _GradingGestureGuideCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.electricLime.withAlpha(120),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.electricLime.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.electricLime,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panduan Pengujian Gesture (NIM Genap)',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '3 Gesture interaktif wajib dengan perubahan visual nyata',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.surfaceBorderSubtle, height: 1),
          const SizedBox(height: 12),

          // 1. Double Tap
          _GestureItem(
            number: '1',
            name: AppConstants.gestureDoubleTapTitle,
            desc: AppConstants.gestureDoubleTapDesc,
            location:
                'Smart Recommendation Card (Dashboard & Layar Rekomendasi)',
            effect: 'Status berubah: Pending ↔ Accepted, aksen border & badge menyala hijau.',
          ),

          const SizedBox(height: 12),

          // 2. Pinch / Scale
          _GestureItem(
            number: '2',
            name: AppConstants.gestureScaleTitle,
            desc: AppConstants.gestureScaleDesc,
            location: 'Sistem Aliran Daya / Energy Flow (Dashboard)',
            effect: 'Komponen membesar/mengecil (0.8x s/d 1.8x), badge indikator zoom & tombol Reset 1.0x muncul.',
          ),

          const SizedBox(height: 12),

          // 3. Swipe / Drag
          _GestureItem(
            number: '3',
            name: AppConstants.gestureSwipeTitle,
            desc: AppConstants.gestureSwipeDesc,
            location: 'Smart Recommendations Carousel (Dashboard)',
            effect: 'Transisi geser kartu (AnimatedSwitcher), nomor halaman & indikator dot bergerak.',
          ),
        ],
      ),
    );
  }
}

class _GestureItem extends StatelessWidget {
  final String number;
  final String name;
  final String desc;
  final String location;
  final String effect;

  const _GestureItem({
    required this.number,
    required this.name,
    required this.desc,
    required this.location,
    required this.effect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.electricLime,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: AppColors.textOnAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: AppTextStyles.bodySmall),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📍 Lokasi: ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '✨ Efek UI: ',
                style: TextStyle(
                  color: AppColors.electricLime,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  effect,
                  style: const TextStyle(
                    color: AppColors.electricLime,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SdgAlignmentCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color badgeColor;
  final IconData icon;

  const _SdgAlignmentCard({
    required this.title,
    required this.desc,
    required this.badgeColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: badgeColor.withAlpha(100)),
            ),
            child: Icon(icon, color: badgeColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(desc, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
