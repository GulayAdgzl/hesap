import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

class ProductFilter {
  ProductFilter._();

  static List<Product> apply({
    required List<Product> products,
    required String filter,
    required String search,
  }) {
    List<Product> result = products;

    if (search.isNotEmpty) {
      result = result
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    switch (filter) {
      case AppStrings.filterCritical:
        result = result.where((p) {
          final ratio = p.quantity / p.maxStock;
          return ratio <= (p.criticalThreshold / 100);
        }).toList();
        break;
      case AppStrings.filterNormal:
        result = result.where((p) {
          final ratio = p.quantity / p.maxStock;
          return ratio > (p.criticalThreshold / 100);
        }).toList();
        break;
      case AppStrings.filterMostConsumed:
        result = List.from(result)
          ..sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      default:
        break;
    }

    return result;
  }
}
