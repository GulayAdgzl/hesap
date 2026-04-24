import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';

class ReportsTrendChart extends StatelessWidget {
  final Map<DateTime, double> series;

  const ReportsTrendChart({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Günlük Maliyet Trendi', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 4),
          Text(
            'Bu hafta için başlıca maliyet değişimi',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: series.isEmpty
                ? const Center(
                    child: Text('Veri yok',
                        style: TextStyle(color: AppColors.muted)),
                  )
                : _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final sorted = series.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final spots = sorted.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.value);
    }).toList();

    final maxY = sorted.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minY = sorted.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return LineChart(
      LineChartData(
        minY: (minY * 0.85).floorToDouble(),
        maxY: (maxY * 1.15).ceilToDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? maxY / 3 : 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppColors.inputBorder,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= sorted.length) {
                  return const SizedBox();
                }
                final date = sorted[idx].key;
                final label = days[date.weekday - 1];
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    label,
                    style: AppTextStyles.caption
                        .copyWith(fontSize: 10, color: AppColors.muted),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.dark.withOpacity(0.85),
            getTooltipItems: (spots) => spots
                .map(
                  (s) => LineTooltipItem(
                    '₺${s.y.toStringAsFixed(0)}',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: 3.5,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.18),
                  AppColors.primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}