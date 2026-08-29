import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';

class ReportsTrendChart extends StatelessWidget {
  final Map<DateTime, double> series;

  const ReportsTrendChart({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.base,
        AppSizes.base,
        AppSizes.base,
        AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: AppRadius.lgBorderRadius,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Günlük Maliyet Trendi',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Bu hafta için başlıca maliyet değişimi',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.appTheme.muted,
            ),
          ),
          const SizedBox(height: AppSizes.base),
          SizedBox(
            height: 130,
            child: series.isEmpty
                ? Center(
                    child: Text(
                      'Veri yok',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.appTheme.muted,
                      ),
                    ),
                  )
                : _ReportsTrendChartBody(
                    series: series,
                    primaryColor: context.colors.primary,
                    gridLineColor: context.appTheme.divider,
                    mutedColor: context.appTheme.muted,
                    tooltipBg: context.isDark
                        ? const Color(0xFF2E2E4E)
                        : const Color(0xFF1A1A2E),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Chart body ayrı widget'a alındı — context renkleri parametre olarak geçiliyor,
/// böylece fl_chart callback'leri içinde BuildContext gerekmez.
class _ReportsTrendChartBody extends StatelessWidget {
  final Map<DateTime, double> series;
  final Color primaryColor;
  final Color gridLineColor;
  final Color mutedColor;
  final Color tooltipBg;

  const _ReportsTrendChartBody({
    required this.series,
    required this.primaryColor,
    required this.gridLineColor,
    required this.mutedColor,
    required this.tooltipBg,
  });

  static const List<String> _days = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz'
  ];

  @override
  Widget build(BuildContext context) {
    final sorted = series.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final spots = sorted
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
        .toList();

    final maxY = sorted.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minY = sorted.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    return LineChart(
      LineChartData(
        minY: (minY * 0.85).floorToDouble(),
        maxY: (maxY * 1.15).ceilToDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? maxY / 3 : 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: gridLineColor,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= sorted.length) return const SizedBox();
                final label = _days[sorted[idx].key.weekday - 1];
                return Padding(
                  padding: const EdgeInsets.only(top: AppSizes.xs + 2),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: mutedColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => tooltipBg.withOpacity(0.9),
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
            color: primaryColor,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: 3.5,
                color: primaryColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.18),
                  primaryColor.withOpacity(0.0),
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
