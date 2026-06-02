class ReportSummary {
  /// Dönemdeki toplam tüketim miktarı (tüm ürünler, birim fark gözetmeksizin)
  final int totalConsumption;

  /// Dönemdeki toplam maliyet (₺)
  final double totalCost;

  /// Bir önceki döneme göre tüketim değişimi (% olarak, null = kıyaslanacak veri yok)
  final double? consumptionChangePercent;

  /// Günlük ortalama maliyet (₺)
  final double dailyAverageCost;

  /// Grafik için günlük maliyet serisi — {tarih: günlük toplam maliyet}
  final Map<DateTime, double> dailyCostSeries;

  const ReportSummary({
    required this.totalConsumption,
    required this.totalCost,
    required this.consumptionChangePercent,
    required this.dailyAverageCost,
    required this.dailyCostSeries,
  });

  static const empty = ReportSummary(
    totalConsumption: 0,
    totalCost: 0,
    consumptionChangePercent: null,
    dailyAverageCost: 0,
    dailyCostSeries: {},
  );
}
