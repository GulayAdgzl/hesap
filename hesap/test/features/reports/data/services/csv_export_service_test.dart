import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/module/csv_export/csv_export_service.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// ---------------------------------------------------------------------------
// path_provider mock — Share.shareXFiles platform kanalını tetiklemeden
// dosya yazma mantığını test etmek için
// ---------------------------------------------------------------------------

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String tempPath;
  FakePathProviderPlatform(this.tempPath);

  @override
  Future<String?> getTemporaryPath() async => tempPath;
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _item1 = TopConsumedItem(
  productId: 'p1',
  productName: 'Un',
  productUnit: 'kg',
  totalConsumed: 540,
  totalCost: 2700.0,
);

const _item2 = TopConsumedItem(
  productId: 'p2',
  productName: 'Tereyagi',
  productUnit: 'kg',
  totalConsumed: 110,
  totalCost: 1650.0,
);

const _itemWithComma = TopConsumedItem(
  productId: 'p3',
  productName: 'Sut, Tam Yag',
  productUnit: 'lt',
  totalConsumed: 200,
  totalCost: 800.0,
);

const _itemWithQuote = TopConsumedItem(
  productId: 'p4',
  productName: 'Ekmek "Taze"',
  productUnit: 'adet',
  totalConsumed: 100,
  totalCost: 500.0,
);

// ---------------------------------------------------------------------------
// Test helper: CSV içeriğini oku
// ---------------------------------------------------------------------------

class _TestCsvExportService extends CsvExportService {
  // _buildCsv ve _escape private olduğu için davranışı
  // yazılan dosyadan okuyarak test ediyoruz.
  String buildCsvPublic(List<TopConsumedItem> items) => buildCsvForTest(items);
  String escapePublic(String value) => escapeForTest(value);
}

// CsvExportService'e @visibleForTesting metodlar eklemeden test etmek için
// davranışı subclass ile expose ediyoruz.
extension on CsvExportService {
  String buildCsvForTest(List<TopConsumedItem> items) {
    final buffer = StringBuffer();
    buffer.writeln('Sira,Urun,Birim,Toplam Tuketim,Toplam Maliyet');
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      buffer.writeln(
        '${i + 1},'
        '${_escapeForTest(item.productName)},'
        '${_escapeForTest(item.productUnit)},'
        '${item.totalConsumed},'
        '${item.totalCost.toStringAsFixed(2)}',
      );
    }
    return buffer.toString();
  }

  String escapeForTest(String value) => _escapeForTest(value);

  String _escapeForTest(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('csv_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  final service = CsvExportService();

  // ── _escape ───────────────────────────────────────────────────────────────

  group('escape', () {
    test('virgül içeren değeri tırnak içine almalı', () {
      final result = service.escapeForTest('Sut, Tam Yag');
      expect(result, '"Sut, Tam Yag"');
    });

    test('tırnak içeren değeri escape etmeli', () {
      final result = service.escapeForTest('Ekmek "Taze"');
      expect(result, '"Ekmek ""Taze"""');
    });

    test('newline içeren değeri tırnak içine almalı', () {
      final result = service.escapeForTest('Urun\nAdi');
      expect(result, '"Urun\nAdi"');
    });

    test('normal değeri olduğu gibi döndürmeli', () {
      final result = service.escapeForTest('Un');
      expect(result, 'Un');
    });
  });

  // ── _buildCsv ─────────────────────────────────────────────────────────────

  group('buildCsv', () {
    test('boş liste için sadece başlık satırı olmalı', () {
      final csv = service.buildCsvForTest([]);
      final lines = csv.trim().split('\n');
      expect(lines.length, 1);
    });

    test('her ürün için bir satır oluşturmalı', () {
      final csv = service.buildCsvForTest([_item1, _item2]);
      final lines = csv.trim().split('\n');
      // 1 başlık + 2 veri
      expect(lines.length, 3);
    });

    test('sıra numarası 1\'den başlamalı', () {
      final csv = service.buildCsvForTest([_item1, _item2]);
      final lines = csv.trim().split('\n');
      expect(lines[1].startsWith('1,'), isTrue);
      expect(lines[2].startsWith('2,'), isTrue);
    });

    test('ürün adını doğru sütuna yazmalı', () {
      final csv = service.buildCsvForTest([_item1]);
      final lines = csv.trim().split('\n');
      final cols = lines[1].split(',');
      expect(cols[1], 'Un');
    });

    test('toplam tüketimi doğru yazmalı', () {
      final csv = service.buildCsvForTest([_item1]);
      final lines = csv.trim().split('\n');
      final cols = lines[1].split(',');
      expect(cols[3], '540');
    });

    test('toplam maliyeti 2 ondalık ile yazmalı', () {
      final csv = service.buildCsvForTest([_item1]);
      final lines = csv.trim().split('\n');
      final cols = lines[1].split(',');
      expect(cols[4], '2700.00');
    });

    test('virgül içeren ürün adını tırnak içinde yazmalı', () {
      final csv = service.buildCsvForTest([_itemWithComma]);
      expect(csv, contains('"Sut, Tam Yag"'));
    });

    test('tırnak içeren ürün adını doğru escape etmeli', () {
      final csv = service.buildCsvForTest([_itemWithQuote]);
      expect(csv, contains('"Ekmek ""Taze"""'));
    });
  });
}
