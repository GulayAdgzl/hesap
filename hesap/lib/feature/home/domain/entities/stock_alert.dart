// stock_alert.dart
enum AlertSeverity { warning, critical }

class StockAlert {
  final String productId;
  final String productName;
  final double remainingAmount;
  final String unit;
  final double estimatedDaysLeft; // "1.5 gün" gösterimi için double (int değil)
  final double criticalThreshold;
  final AlertSeverity severity;

  const StockAlert({
    required this.productId,
    required this.productName,
    required this.remainingAmount,
    required this.unit,
    required this.estimatedDaysLeft,
    required this.criticalThreshold,
    required this.severity,
  });

  bool get isCritical => severity == AlertSeverity.critical;

  String get remainingFormatted =>
      '${remainingAmount.toStringAsFixed(1)} $unit';

  // "Tahmini bitiş: 1.5 gün"
  String get estimatedDaysLeftFormatted => estimatedDaysLeft >= 999
      ? '—'
      : '${estimatedDaysLeft.toStringAsFixed(1)} gün';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StockAlert &&
        other.productId == productId &&
        other.remainingAmount == remainingAmount &&
        other.estimatedDaysLeft == estimatedDaysLeft &&
        other.severity == severity;
  }

  @override
  int get hashCode => Object.hash(
        productId,
        remainingAmount,
        estimatedDaysLeft,
        severity,
      );

  @override
  String toString() => 'StockAlert('
      'productName: $productName, remainingAmount: $remainingAmount $unit, '
      'estimatedDaysLeft: $estimatedDaysLeft, severity: $severity)';
}
