import 'package:hesap/product/model/daily_stock_entry_model.dart';
import 'package:hive_ce/hive.dart';

import '../../../../product/model/product_model.dart';

abstract class HomeLocalDataSource {
  Future<Map<String, dynamic>> getHomeSummaryData();
  Future<List<Map<String, dynamic>>> getWeeklyConsumptionData();
  Future<List<Map<String, dynamic>>> getAlertsData();
  Future<List<Map<String, dynamic>>> getForecastsData(int forecastPeriod);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final Box<ProductModel> productBox;
  final Box<DailyStockEntryModel> entryBox;

  HomeLocalDataSourceImpl({
    required this.productBox,
    required this.entryBox,
  });

  // ── getHomeSummaryData ─────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getHomeSummaryData() async {
    final products = productBox.values.toList();
    final entries = entryBox.values.toList();
    final todayStr = _dateKey(DateTime.now());

    double totalStockValue = 0;
    double dailyCost = 0;
    int criticalCount = 0;
    String? topConsumedName;
    double topConsumedAmount = 0;
    String? topConsumedUnit;

    for (final product in products) {
      // Ürünün son entry'si → mevcut stok
      final productEntries = _entriesForProduct(product.id, entries);
      final latestStock = productEntries.isEmpty
          ? product.quantity.toDouble()
          : productEntries.first.currentQuantity.toDouble();

      // Toplam stok değeri = mevcut stok × birim fiyat
      totalStockValue += latestStock * product.price;

      // Bugünkü tüketim
      final todayEntry =
          productEntries.where((e) => _dateKey(e.date) == todayStr).toList();

      if (todayEntry.isNotEmpty) {
        // consumed = previousQuantity - currentQuantity
        final consumed = (todayEntry.first.previousQuantity -
                todayEntry.first.currentQuantity)
            .toDouble()
            .clamp(0.0, double.infinity);

        dailyCost += consumed * product.price;

        if (consumed > topConsumedAmount) {
          topConsumedAmount = consumed;
          topConsumedName = product.name;
          topConsumedUnit = product.unit;
        }
      }

      // Kritik kontrol: mevcut stok / maxStock <= criticalThreshold%
      if (product.maxStock > 0) {
        final ratio = latestStock / product.maxStock;
        if (ratio <= product.criticalThreshold / 100) {
          criticalCount++;
        }
      }
    }

    return {
      'totalStockValue': totalStockValue,
      'dailyCost': dailyCost,
      'criticalProductCount': criticalCount,
      'topConsumedProductName': topConsumedName,
      'topConsumedAmount': topConsumedAmount,
      'topConsumedUnit': topConsumedUnit,
    };
  }

  // ── getWeeklyConsumptionData ───────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getWeeklyConsumptionData() async {
    final now = DateTime.now();
    final entries = entryBox.values.toList();
    final result = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = _dateKey(date);

      final dayEntries =
          entries.where((e) => _dateKey(e.date) == dateStr).toList();

      // Toplam günlük tüketim
      final actual = dayEntries.fold<double>(
        0.0,
        (sum, e) =>
            sum +
            (e.previousQuantity - e.currentQuantity).clamp(0, double.infinity),
      );

      final forecast = _calculateForecast(date, entries);

      result.add({
        'date': date.millisecondsSinceEpoch,
        'actual': actual,
        'forecast': forecast,
      });
    }

    return result;
  }

  // ── getAlertsData ──────────────────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getAlertsData() async {
    final products = productBox.values.toList();
    final entries = entryBox.values.toList();
    final alerts = <Map<String, dynamic>>[];

    for (final product in products) {
      final productEntries = _entriesForProduct(product.id, entries);
      final latestStock = productEntries.isEmpty
          ? product.quantity.toDouble()
          : productEntries.first.currentQuantity.toDouble();

      if (product.maxStock <= 0) continue;

      final ratio = latestStock / product.maxStock;
      final threshold = product.criticalThreshold / 100;

      if (ratio > threshold) continue;

      final avgDaily = _averageDailyConsumption(product.id, entries);
      final daysLeft = avgDaily > 0 ? (latestStock / avgDaily).floor() : 999;

      alerts.add({
        'productId': product.id,
        'productName': product.name,
        'remainingAmount': latestStock,
        'unit': product.unit,
        'estimatedDaysLeft': daysLeft,
        'criticalThreshold': product.criticalThreshold,
        'severity': ratio <= threshold * 0.5 ? 'critical' : 'warning',
      });
    }

    alerts.sort((a, b) => (a['estimatedDaysLeft'] as int)
        .compareTo(b['estimatedDaysLeft'] as int));

    return alerts;
  }

  // ── getForecastsData ───────────────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getForecastsData(
      int forecastPeriod) async {
    final products = productBox.values.toList();
    final entries = entryBox.values.toList();
    final forecasts = <Map<String, dynamic>>[];

    for (final product in products) {
      final productEntries = _entriesForProduct(product.id, entries);
      if (productEntries.isEmpty) continue;

      // Son forecastPeriod entry'nin ortalaması
      final recent = productEntries.take(forecastPeriod).toList();
      final avgRecent = _avgConsumed(recent);

      // Önceki period ortalaması → trend
      final older =
          productEntries.skip(forecastPeriod).take(forecastPeriod).toList();
      final avgOlder = older.isEmpty ? avgRecent : _avgConsumed(older);

      final delta = avgRecent - avgOlder;
      final String trend;
      if (avgOlder > 0 && delta > avgOlder * 0.05) {
        trend = 'increasing';
      } else if (avgOlder > 0 && delta < -avgOlder * 0.05) {
        trend = 'decreasing';
      } else {
        trend = 'stable';
      }

      if (avgRecent > 0) {
        forecasts.add({
          'productId': product.id,
          'productName': product.name,
          'unit': product.unit,
          'forecastAmount': avgRecent,
          'previousAmount': avgOlder,
          'trend': trend,
        });
      }
    }

    forecasts.sort((a, b) => (b['forecastAmount'] as double)
        .compareTo(a['forecastAmount'] as double));

    return forecasts;
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  List<DailyStockEntryModel> _entriesForProduct(
      String productId, List<DailyStockEntryModel> entries) {
    return entries.where((e) => e.productId == productId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double _avgConsumed(List<DailyStockEntryModel> entries) {
    if (entries.isEmpty) return 0.0;
    final total = entries.fold<double>(
      0.0,
      (sum, e) =>
          sum +
          (e.previousQuantity - e.currentQuantity).clamp(0, double.infinity),
    );
    return total / entries.length;
  }

  double _averageDailyConsumption(
      String productId, List<DailyStockEntryModel> all) {
    final recent = _entriesForProduct(productId, all).take(7).toList();
    return _avgConsumed(recent);
  }

  double _calculateForecast(
      DateTime forDate, List<DailyStockEntryModel> entries) {
    double total = 0;
    int count = 0;

    for (int i = 1; i <= 7; i++) {
      final dateStr = _dateKey(forDate.subtract(Duration(days: i)));
      final dayEntries =
          entries.where((e) => _dateKey(e.date) == dateStr).toList();

      if (dayEntries.isNotEmpty) {
        total += dayEntries.fold<double>(
          0.0,
          (sum, e) =>
              sum +
              (e.previousQuantity - e.currentQuantity)
                  .clamp(0, double.infinity),
        );
        count++;
      }
    }

    return count > 0 ? total / count : 0.0;
  }
}
