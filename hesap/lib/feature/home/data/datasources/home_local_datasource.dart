import 'package:hesap/product/model/daily_stock_entry_model.dart';
import 'package:hive_ce/hive.dart';

import '../../../../product/model/product_model.dart';

abstract class HomeLocalDataSource {
  Future<Map<String, dynamic>> getHomeSummaryData();
  Future<Map<String, dynamic>> getWeeklyConsumptionData();
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

  // ── getHomeSummaryData ────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getHomeSummaryData() async {
    final products = productBox.values.toList();
    final entries = entryBox.values.toList();
    final todayStr = _dateKey(DateTime.now());

    double totalConsumption = 0; // "Toplam Tüketim" kartı — kg/gün
    double dailyCost = 0;
    int criticalCount = 0;
    String? topConsumedName;
    double topConsumedAmount = 0;
    String? topConsumedUnit;
    final productStocks = <Map<String, dynamic>>[];

    for (final product in products) {
      final productEntries = _entriesForProduct(product.id, entries);
      final latestStock = productEntries.isEmpty
          ? product.quantity.toDouble()
          : productEntries.first.currentQuantity.toDouble();

      final todayEntry =
          productEntries.where((e) => _dateKey(e.date) == todayStr).toList();

      double consumedToday = 0;
      if (todayEntry.isNotEmpty) {
        consumedToday = (todayEntry.first.previousQuantity -
                todayEntry.first.currentQuantity)
            .toDouble()
            .clamp(0.0, double.infinity);

        // "Toplam Tüketim" kartı: bugün tüketilen miktarların (kg) toplamı
        totalConsumption += consumedToday;
        // "Günlük Maliyet" kartı: tüketilen miktar × birim fiyat
        dailyCost += consumedToday * product.price;

        if (consumedToday > topConsumedAmount) {
          topConsumedAmount = consumedToday;
          topConsumedName = product.name;
          topConsumedUnit = product.unit;
        }
      }

      // "Ürün Stokları" listesi
      productStocks.add({
        'productId': product.id,
        'productName': product.name,
        'unit': product.unit,
        'remainingAmount': latestStock,
        'consumedToday': consumedToday,
      });

      if (product.maxStock > 0) {
        final ratio = latestStock / product.maxStock;
        if (ratio <= product.criticalThreshold / 100) {
          criticalCount++;
        }
      }
    }

    // En çok tüketilen üründen aza doğru sırala
    productStocks.sort((a, b) =>
        (b['consumedToday'] as double).compareTo(a['consumedToday'] as double));

    return {
      'totalConsumption': totalConsumption,
      'dailyCost': dailyCost,
      'criticalProductCount': criticalCount,
      'topConsumedProductName': topConsumedName,
      'topConsumedAmount': topConsumedAmount,
      'topConsumedUnit': topConsumedUnit,
      'productStocks': productStocks,
    };
  }

  // ── getWeeklyConsumptionData ──────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getWeeklyConsumptionData() async {
    final now = DateTime.now();
    final entries = entryBox.values.toList();
    final days = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = _dateKey(date);

      final dayEntries =
          entries.where((e) => _dateKey(e.date) == dateStr).toList();

      final actual = dayEntries.fold<double>(
        0.0,
        (sum, e) =>
            sum +
            (e.previousQuantity - e.currentQuantity).clamp(0, double.infinity),
      );

      final forecast = _calculateForecast(date, entries);

      days.add({
        'date': date.millisecondsSinceEpoch,
        'actual': actual,
        'forecast': forecast,
      });
    }

    // "+%28 geçen haftaya göre" için önceki 7 günün (8-14 gün önce) toplamı
    double previousWeekTotal = 0;
    for (int i = 13; i >= 7; i--) {
      final dateStr = _dateKey(now.subtract(Duration(days: i)));
      final dayEntries =
          entries.where((e) => _dateKey(e.date) == dateStr).toList();
      previousWeekTotal += dayEntries.fold<double>(
        0.0,
        (sum, e) =>
            sum +
            (e.previousQuantity - e.currentQuantity).clamp(0, double.infinity),
      );
    }

    return {
      'days': days,
      'previousWeekTotal': previousWeekTotal,
    };
  }

  // ── getAlertsData ─────────────────────────────────────────────────

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
      // "1.5 gün" gibi ondalık gösterim için floor() kaldırıldı
      final daysLeft = avgDaily > 0 ? latestStock / avgDaily : 999.0;

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

    alerts.sort((a, b) => (a['estimatedDaysLeft'] as double)
        .compareTo(b['estimatedDaysLeft'] as double));

    return alerts;
  }

  // ── getForecastsData ──────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getForecastsData(
      int forecastPeriod) async {
    final products = productBox.values.toList();
    final entries = entryBox.values.toList();
    final forecasts = <Map<String, dynamic>>[];

    for (final product in products) {
      final productEntries = _entriesForProduct(product.id, entries);
      if (productEntries.isEmpty) continue;

      final recent = productEntries.take(forecastPeriod).toList();
      final avgRecent = _avgConsumed(recent);

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

  // ── Private helpers ───────────────────────────────────────────────

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
