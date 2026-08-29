import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/usecases/add_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/delete_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/update_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/widgets/product_filter.dart';
import 'package:hesap/product/widget/product_card.dart';

import '../mixin/products_page_mixin.dart';
import '../view_model/products_ui_state.dart';
import '../view_model/products_view_model.dart';

part 'products_page_parts.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    super.key,
    required this.getAllProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
  });

  final GetAllProductsUseCase getAllProducts;
  final AddProductUseCase addProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProduct;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

final class _ProductsPageState extends State<ProductsPage>
    with ProductsPageMixin<ProductsPage> {
  static const _filters = [
    AppStrings.filterAll,
    AppStrings.filterCritical,
    AppStrings.filterNormal,
    AppStrings.filterMostConsumed,
  ];

  @override
  ProductsViewModel buildViewModel() => ProductsViewModel(
        getAllProducts: widget.getAllProducts,
        addProduct: widget.addProduct,
        updateProduct: widget.updateProduct,
        deleteProduct: widget.deleteProduct,
      );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<ProductsUiState>(
          valueListenable: viewModel.state,
          builder: (context, state, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg,
                    AppSizes.base,
                    AppSizes.lg,
                    AppSizes.sm,
                  ),
                  child: Text(
                    AppStrings.productsTitle,
                    style: context.textTheme.titleLarge,
                  ),
                ),
                _SearchBar(onChanged: onSearchChanged),
                _FilterChips(
                  filters: _filters,
                  selected: state.filter.isEmpty
                      ? AppStrings.filterAll
                      : state.filter,
                  onChanged: onFilterChanged,
                ),
                const SizedBox(height: AppSizes.md),
                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddProductSheet,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.baseBorderRadius,
        ),
        child: const Icon(Icons.add, size: AppSizes.xxl - 4),
      ),
    );
  }

  // ── Body switch ────────────────────────────────────────────────────────────

  Widget _buildBody(ProductsUiState state) {
    if (state.isLoading) return const _ProductsLoading();
    if (state.hasError) return _ProductsError(message: state.error!);

    if (!state.hasProducts) return const _ProductsEmpty();

    final filtered = ProductFilter.apply(
      products: state.products,
      filter: state.filter.isEmpty ? AppStrings.filterAll : state.filter,
      search: state.search,
    );

    if (filtered.isEmpty) {
      return _ProductsFilterEmpty(
        filter: state.filter.isEmpty ? AppStrings.filterAll : state.filter,
      );
    }

    return _ProductsList(
      products: filtered,
      onEdit: showEditProductSheet,
      onDelete: confirmDelete,
    );
  }
}
