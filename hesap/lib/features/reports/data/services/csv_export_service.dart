import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hesap/features/reports/domain/entities/report_filter.dart';
import 'package:hesap/features/reports/domain/entities/top_consumed_item.dart';

class CsvExportService {
  /// [items] listesini CSV dosyasına yazar ve share sheet açar.
  Future<void> exportTopConsumed({
    required List<TopConsumedItem> items,
    required ReportFilter filter,
  }) async {
    final csv = _buildCsv(items);
    final file = await _writeTemp(csv, filter);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: _subject(filter),
    );
  }

  // -------------------------------------------------------------------------

  String _buildCsv(List<TopConsumedItem> items) {
    final buffer = StringBuffer();

    // Başlık satırı
    buffer.writeln('Sıra,Ürün,Birim,Toplam Tüketim,Toplam Maliyet (₺)');

    // Veri satırları
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      buffer.writeln(
        '${i + 1},'
        '${_escape(item.productName)},'
        '${_escape(item.productUnit)},'
        '${item.totalConsumed},'
        '${item.totalCost.toStringAsFixed(2)}',
      );
    }

    return buffer.toString();
  }

  /// CSV hücrelerinde virgül veya tırnak varsa escape et.
  String _escape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  @visibleForTesting
  String buildCsvForTest(List<TopConsumedItem> items) => _buildCsv(items);

  @visibleForTesting
  String escapeForTest(String value) => _escape(value);

  Future<File> _writeTemp(String csv, ReportFilter filter) async {
    final dir = await getTemporaryDirectory();
    final fileName = 'en_cok_tuketilenler_${_dateRange(filter)}.csv';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csv, flush: true);
    return file;
  }

  String _dateRange(ReportFilter filter) {
    final start = _fmt(filter.startDate);
    final end = _fmt(filter.endDate);
    return '${start}_$end';
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _subject(ReportFilter filter) =>
      'En Çok Tüketilenler | ${_fmt(filter.startDate)} – ${_fmt(filter.endDate)}';
}
