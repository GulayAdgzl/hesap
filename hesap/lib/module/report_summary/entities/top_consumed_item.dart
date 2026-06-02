class TopConsumedItem {
  final String productId;
  final String productName;
  final String productUnit;
  final int totalConsumed;
  final double totalCost;

  const TopConsumedItem({
    required this.productId,
    required this.productName,
    required this.productUnit,
    required this.totalConsumed,
    required this.totalCost,
  });
}
