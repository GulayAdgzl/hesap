enum AlertSeverity { warning, critical }

class StockAlert {
  final String productId;
  final String productName;
  final double remainingAmount;
  final String unit;
  final int estimatedDaysLeft;
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
      'productName: $productName, '
      'remainingAmount: $remainingAmount $unit, '
      'estimatedDaysLeft: $estimatedDaysLeft, '
      'severity: $severity)';
}
