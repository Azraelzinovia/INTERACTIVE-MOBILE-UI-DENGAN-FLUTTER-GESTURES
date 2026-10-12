import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_energy_data.dart';

/// Interactive 24-Hour Energy Comparison Chart (Solar PV vs Household Load).
/// Built with Flutter CustomPainter with smooth cubic curves, gridlines, and touch scrubbing.
class EnergyComparisonChart extends StatefulWidget {
  final List<HourlyTelemetry> telemetry;

  const EnergyComparisonChart({super.key, required this.telemetry});

  @override
  State<EnergyComparisonChart> createState() => _EnergyComparisonChartState();
}

class _EnergyComparisonChartState extends State<EnergyComparisonChart> {
  int? _selectedHourIndex;

  @override
  Widget build(BuildContext context) {
    final telemetry = widget.telemetry;
    final selectedRecord =
        _selectedHourIndex != null && _selectedHourIndex! < telemetry.length
        ? telemetry[_selectedHourIndex!]
        : null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header & Inspection Tooltip Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kurva Daya 24 Jam', style: AppTextStyles.titleMedium),
                  Text(
                    'Sentuh grafik untuk inspeksi per jam',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              if (selectedRecord != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedRecord.hourLabel,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '☀️ ${selectedRecord.solarKwh.toStringAsFixed(1)} kW',
                        style: const TextStyle(
                          color: AppColors.solarGold,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '⚡ ${selectedRecord.consumptionKwh.toStringAsFixed(1)} kW',
                        style: const TextStyle(
                          color: AppColors.consumptionOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Chart Canvas Area with Touch Gesture Detector
          SizedBox(
            height: 200,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    final boxWidth = constraints.maxWidth;
                    final chartWidth = boxWidth - 40; // padding for Y axis
                    final localX = (details.localPosition.dx - 35).clamp(
                      0.0,
                      chartWidth,
                    );
                    final fraction = localX / chartWidth;
                    final index = (fraction * (telemetry.length - 1)).round();
                    setState(() {
                      _selectedHourIndex = index;
                    });
                  },
                  onTapDown: (details) {
                    final boxWidth = constraints.maxWidth;
                    final chartWidth = boxWidth - 40;
                    final localX = (details.localPosition.dx - 35).clamp(
                      0.0,
                      chartWidth,
                    );
                    final fraction = localX / chartWidth;
                    final index = (fraction * (telemetry.length - 1)).round();
                    setState(() {
                      _selectedHourIndex = index;
                    });
                  },
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, 200),
                    painter: _EnergyChartPainter(
                      data: telemetry,
                      selectedIndex: _selectedHourIndex,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Legend Bar
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChartLegendItem(
                color: AppColors.solarGold,
                label: 'Produksi Solar PV',
              ),
              SizedBox(width: 20),
              _ChartLegendItem(
                color: AppColors.consumptionOrange,
                label: 'Beban Konsumsi Rumah',
              ),
              SizedBox(width: 20),
              _ChartLegendItem(
                color: AppColors.electricLime,
                label: 'Zona Surplus Daya',
                isSquare: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSquare;

  const _ChartLegendItem({
    required this.color,
    required this.label,
    this.isSquare = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSquare ? 10 : 14,
          height: isSquare ? 10 : 3.5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isSquare ? 2 : 4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EnergyChartPainter extends CustomPainter {
  final List<HourlyTelemetry> data;
  final int? selectedIndex;

  _EnergyChartPainter({required this.data, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 32.0;
    const rightPad = 12.0;
    const topPad = 16.0;
    const bottomPad = 26.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    const maxVal = 7.0; // 0 to 7 kWh scale

    // Y Gridlines and labels
    final gridPaint = Paint()
      ..color = AppColors.surfaceBorderSubtle
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const ySteps = [0.0, 2.0, 4.0, 6.0];
    for (final val in ySteps) {
      final y = topPad + chartHeight * (1.0 - (val / maxVal));
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: '${val.toInt()}k',
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(leftPad - textPainter.width - 6, y - 6));
    }

    if (data.isEmpty) return;

    // Build Paths for Solar and Consumption
    final solarPath = Path();
    final solarFillPath = Path();
    final consumptionPath = Path();

    Offset getPoint(int i, double val) {
      final x = leftPad + (i / (data.length - 1)) * chartWidth;
      final y = topPad + chartHeight * (1.0 - (val / maxVal));
      return Offset(x, y);
    }

    // Solar Path
    final firstSolar = getPoint(0, data[0].solarKwh);
    solarPath.moveTo(firstSolar.dx, firstSolar.dy);
    solarFillPath.moveTo(firstSolar.dx, topPad + chartHeight);
    solarFillPath.lineTo(firstSolar.dx, firstSolar.dy);

    for (int i = 0; i < data.length - 1; i++) {
      final p0 = getPoint(i, data[i].solarKwh);
      final p1 = getPoint(i + 1, data[i + 1].solarKwh);
      final cx = (p0.dx + p1.dx) / 2;
      solarPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
      solarFillPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    solarFillPath.lineTo(leftPad + chartWidth, topPad + chartHeight);
    solarFillPath.close();

    // Draw solar gradient fill under curve
    final solarFillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.solarGold.withAlpha(80),
          AppColors.electricLime.withAlpha(20),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight))
      ..style = PaintingStyle.fill;

    canvas.drawPath(solarFillPath, solarFillPaint);

    // Stroke Solar Path
    final solarStrokePaint = Paint()
      ..color = AppColors.solarGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(solarPath, solarStrokePaint);

    // Consumption Path
    final firstCons = getPoint(0, data[0].consumptionKwh);
    consumptionPath.moveTo(firstCons.dx, firstCons.dy);

    for (int i = 0; i < data.length - 1; i++) {
      final p0 = getPoint(i, data[i].consumptionKwh);
      final p1 = getPoint(i + 1, data[i + 1].consumptionKwh);
      final cx = (p0.dx + p1.dx) / 2;
      consumptionPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final consumptionStrokePaint = Paint()
      ..color = AppColors.consumptionOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(consumptionPath, consumptionStrokePaint);

    // X-Axis Hour Labels (00, 06, 12, 18, 23)
    const labelIndices = [0, 6, 12, 18, 23];
    for (final idx in labelIndices) {
      if (idx < data.length) {
        final x = leftPad + (idx / (data.length - 1)) * chartWidth;
        textPainter.text = TextSpan(
          text: data[idx].hourLabel,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - 18),
        );
      }
    }

    // Touch Indicator Scrubber Line & Dot
    if (selectedIndex != null &&
        selectedIndex! >= 0 &&
        selectedIndex! < data.length) {
      final item = data[selectedIndex!];
      final solarPt = getPoint(selectedIndex!, item.solarKwh);
      final consPt = getPoint(selectedIndex!, item.consumptionKwh);

      final scrubberPaint = Paint()
        ..color = AppColors.electricLime.withAlpha(150)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(solarPt.dx, topPad),
        Offset(solarPt.dx, topPad + chartHeight),
        scrubberPaint,
      );

      // Solar Dot
      canvas.drawCircle(solarPt, 5.0, Paint()..color = AppColors.solarGold);
      canvas.drawCircle(solarPt, 2.5, Paint()..color = AppColors.background);

      // Consumption Dot
      canvas.drawCircle(
        consPt,
        5.0,
        Paint()..color = AppColors.consumptionOrange,
      );
      canvas.drawCircle(consPt, 2.5, Paint()..color = AppColors.background);
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.data != data;
  }
}
