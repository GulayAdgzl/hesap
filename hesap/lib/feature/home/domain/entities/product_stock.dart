class ProductStock {
  final String productId;
  final String productName;
  final String unit;
  final double remainingAmount; // "360 kg kalan"
  final double consumedToday; // "-540 kg bugün"

  const ProductStock({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.remainingAmount,
    required this.consumedToday,
  });

  String get remainingFormatted =>
      '${remainingAmount.toStringAsFixed(0)} $unit kalan';

  String get consumedFormatted =>
      '-${consumedToday.toStringAsFixed(0)} $unit bugün';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductStock &&
        other.productId == productId &&
        other.remainingAmount == remainingAmount &&
        other.consumedToday == consumedToday;
  }

  @override
  int get hashCode => Object.hash(productId, remainingAmount, consumedToday);

  @override
  String toString() =>
      'ProductStock(productName: $productName, remainingAmount: $remainingAmount $unit, consumedToday: $consumedToday $unit)';
}
