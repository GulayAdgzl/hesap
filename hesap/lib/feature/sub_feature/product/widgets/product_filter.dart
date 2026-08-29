import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

/// Ürün listesine filtre ve arama uygulayan yardımcı sınıf.
///
/// - Saf fonksiyon yapısı: dış bağımlılık yoktur.
/// - [apply] her çağrıda yeni bir liste döndürür; orijinale dokunmaz.
abstract final class ProductFilter {
  ProductFilter._();

  static List<Product> apply({
    required List<Product> products,
    required String filter,
    required String search,
  }) {
    List<Product> result = products;

    if (search.isNotEmpty) {
      result = result
          .where(
            (p) => p.name.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }

    switch (filter) {
      case AppStrings.filterCritical:
        result = result.where((p) {
          if (p.maxStock <= 0) return false;
          return (p.quantity / p.maxStock) <= (p.criticalThreshold / 100);
        }).toList();

      case AppStrings.filterNormal:
        result = result.where((p) {
          if (p.maxStock <= 0) return true;
          return (p.quantity / p.maxStock) > (p.criticalThreshold / 100);
        }).toList();

      case AppStrings.filterMostConsumed:
        result = List.from(result)
          ..sort((a, b) => b.quantity.compareTo(a.quantity));
    }

    return result;
  }
}
