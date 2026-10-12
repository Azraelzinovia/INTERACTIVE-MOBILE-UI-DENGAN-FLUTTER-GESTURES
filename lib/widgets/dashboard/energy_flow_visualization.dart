import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/energy_data.dart';
import '../../services/energy_service.dart';

/// Interactive Energy Flow Visualization using Stack and CustomPainter.
/// Implements GESTURE 2: Scale/Pinch (0.8x - 1.8x) with live electrical flow animations.
class EnergyFlowVisualization extends StatefulWidget {
  final EnergyData data;

  const EnergyFlowVisualization({super.key, required this.data});

  @override
  State<EnergyFlowVisualization> createState() =>
      _EnergyFlowVisualizationState();
}

class _EnergyFlowVisualizationState extends State<EnergyFlowVisualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  // Local state for pinch/scale gesture
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  static const double _minScale = 0.8;
  static const double _maxScale = 1.8;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync with global service if available
    try {
      final service = EnergyScope.of(context);
      _currentScale = service.currentScale;
    } catch (_) {}
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentScale = (_baseScale * details.scale).clamp(_minScale, _maxScale);
    });
    // Sync with service
    try {
      EnergyScope.of(context).setScale(_currentScale);
    } catch (_) {}
  }

  void _resetScale() {
    setState(() {
      _currentScale = 1.0;
    });
    try {
      EnergyScope.of(context).resetScale();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.data.status.color;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header bar with gesture status indicator and reset control
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.electricLime.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.pinch_rounded,
                        size: 16,
                        color: AppColors.electricLime,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sistem Aliran Daya (Pinchable)',
                          style: AppTextStyles.titleMedium,
                        ),
                        Text(
                          'Gunakan 2 jari untuk Pinch / Zoom',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),

                // Scale Pill & Reset Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Text(
                        '${_currentScale.toStringAsFixed(2)}x',
                        style: const TextStyle(
                          color: AppColors.electricLime,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if ((_currentScale - 1.0).abs() > 0.05) ...[
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: _resetScale,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.electricLime.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.electricLime.withAlpha(100),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.electricLime,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.surfaceBorderSubtle, height: 1),

          // Pinchable Interactive Viewport Area
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
            child: SizedBox(
              height: 250,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _currentScale,
                      child: Stack(
                        children: [
                          // Background animated circuit and energy flow paths
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _EnergyFlowPathPainter(
                                pulsePhase: _pulseController.value,
                                solarKwh: widget.data.solarProduction,
                                consumptionKwh: widget.data.energyConsumption,
                                balanceKwh: widget.data.energyBalance,
                                statusColor: statusColor,
                              ),
                            ),
                          ),

                          // Node 1: Solar Photovoltaic (Top Center)
                          Align(
                            alignment: const Alignment(0, -0.75),
                            child: _FlowNode(
                              icon: Icons.solar_power_rounded,
                              label: 'Solar PV',
                              rate:
                                  '${widget.data.solarProduction.toStringAsFixed(1)} kW',
                              color: AppColors.solarGold,
                            ),
                          ),

                          // Node 2: Smart Hybrid Inverter (Center Core)
                          Align(
                            alignment: const Alignment(0, 0.05),
                            child: _InverterCenterNode(
                              statusColor: statusColor,
                              pulseValue: _pulseController.value,
                            ),
                          ),

                          // Node 3: Battery Storage (Bottom Left)
                          Align(
                            alignment: const Alignment(-0.65, 0.75),
                            child: _FlowNode(
                              icon: Icons.battery_charging_full_rounded,
                              label: 'Baterai ESS',
                              rate: '${widget.data.batteryPercentage}%',
                              color: widget.data.batteryPercentage > 25
                                  ? AppColors.batteryCyan
                                  : AppColors.alertRed,
                            ),
                          ),

                          // Node 4: Home Load (Bottom Right)
                          Align(
                            alignment: const Alignment(0.65, 0.75),
                            child: _FlowNode(
                              icon: Icons.roofing_rounded,
                              label: 'Beban Rumah',
                              rate:
                                  '${widget.data.energyConsumption.toStringAsFixed(1)} kW',
                              color: AppColors.consumptionOrange,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Central Inverter Distribution Hub Node
class _InverterCenterNode extends StatelessWidget {
  final Color statusColor;
  final double pulseValue;

  const _InverterCenterNode({
    required this.statusColor,
    required this.pulseValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        shape: BoxShape.circle,
        border: Border.all(color: statusColor, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: statusColor.withAlpha(
              (70 + 40 * math.sin(pulseValue * 2 * math.pi)).round().clamp(
                0,
                255,
              ),
            ),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.change_circle_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            Text(
              'INVERTER',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Node representation for Solar, Battery, or Home
class _FlowNode extends StatelessWidget {
  final IconData icon;
  final String label;
  final String rate;
  final Color color;

  const _FlowNode({
    required this.icon,
    required this.label,
    required this.rate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(120), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(30),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                rate,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// CustomPainter drawing animated electric pathways between components
class _EnergyFlowPathPainter extends CustomPainter {
  final double pulsePhase; // 0.0 to 1.0
  final double solarKwh;
  final double consumptionKwh;
  final double balanceKwh;
  final Color statusColor;

  _EnergyFlowPathPainter({
    required this.pulsePhase,
    required this.solarKwh,
    required this.consumptionKwh,
    required this.balanceKwh,
    required this.statusColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.48);
    final solarPos = Offset(size.width / 2, size.height * 0.16);
    final batteryPos = Offset(size.width * 0.28, size.height * 0.82);
    final homePos = Offset(size.width * 0.72, size.height * 0.82);

    final conduitPaint = Paint()
      ..color = AppColors.surfaceBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Base conduit lines
    canvas.drawLine(solarPos, center, conduitPaint);
    canvas.drawLine(center, batteryPos, conduitPaint);
    canvas.drawLine(center, homePos, conduitPaint);

    // Draw animated moving energy particles
    if (solarKwh > 0.1) {
      _drawMovingParticles(canvas, solarPos, center, AppColors.solarGold, 3);
    }
    if (consumptionKwh > 0.1) {
      _drawMovingParticles(
        canvas,
        center,
        homePos,
        AppColors.consumptionOrange,
        3,
      );
    }
    // Battery line: if balance > 0 (charging), flow center -> battery; if deficit, flow battery -> center
    if (balanceKwh >= 0) {
      _drawMovingParticles(
        canvas,
        center,
        batteryPos,
        AppColors.batteryCyan,
        3,
      );
    } else {
      _drawMovingParticles(
        canvas,
        batteryPos,
        center,
        AppColors.batteryCyan,
        3,
      );
    }
  }

  void _drawMovingParticles(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    int count,
  ) {
    for (int i = 0; i < count; i++) {
      final t = (pulsePhase + (i / count)) % 1.0;
      final currentPos = Offset.lerp(start, end, t)!;

      final glowPaint = Paint()
        ..color = color.withAlpha(
          (180 * math.sin(t * math.pi)).round().clamp(0, 255),
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(currentPos, 3.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyFlowPathPainter oldDelegate) {
    return oldDelegate.pulsePhase != pulsePhase ||
        oldDelegate.solarKwh != solarKwh ||
        oldDelegate.consumptionKwh != consumptionKwh ||
        oldDelegate.balanceKwh != balanceKwh;
  }
}
