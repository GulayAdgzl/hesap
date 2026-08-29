import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/widgets/add_product_sheet.dart';
import 'package:hesap/feature/sub_feature/product/widgets/edit_product_sheet.dart';

import '../view_model/products_ui_state.dart';
import '../view_model/products_view_model.dart';

mixin ProductsPageMixin<T extends StatefulWidget> on State<T> {
  late final ProductsViewModel viewModel;

  ProductsViewModel buildViewModel();

  // ── Yaşam döngüsü ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    viewModel = buildViewModel();
    viewModel.loadProducts();
    viewModel.state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    viewModel.state.removeListener(_onStateChanged);
    viewModel.dispose();
    super.dispose();
  }

  // ── State dinleyici ────────────────────────────────────────────────────────

  void _onStateChanged() {
    final s = viewModel.state.value;
    if (s.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.error!),
          backgroundColor: context.appTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.mdBorderRadius,
          ),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          viewModel.state.value =
              viewModel.state.value.copyWith(clearError: true);
        }
      });
    }
  }

  // ── Sheet aksiyonları ──────────────────────────────────────────────────────

  void showAddProductSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddProductSheet(
        onSubmit: ({
          required name,
          required unit,
          required price,
          required quantity,
          required criticalThreshold,
          required maxStock,
        }) {
          viewModel.addProduct(
            name: name,
            unit: unit,
            price: price,
            quantity: quantity,
            criticalThreshold: criticalThreshold,
            maxStock: maxStock,
          );
        },
      ),
    );
  }

  void showEditProductSheet(Product product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProductSheet(
        product: product,
        onSubmit: (updated) => viewModel.updateProduct(updated),
      ),
    );
  }

  Future<void> confirmDelete(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.lgBorderRadius,
        ),
        title: Text(
          AppStrings.deleteProduct,
          style: context.textTheme.titleMedium,
        ),
        content: Text(
          '"${product.name}" ${AppStrings.deleteConfirm}',
          style: context.textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              AppStrings.cancel,
              style: context.textTheme.labelLarge
                  ?.copyWith(color: context.appTheme.muted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              AppStrings.deleteYes,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.appTheme.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      viewModel.deleteProduct(product.id);
    }
  }

  // ── Filtre / Arama ─────────────────────────────────────────────────────────

  void onFilterChanged(String filter) => viewModel.updateFilter(filter);
  void onSearchChanged(String search) => viewModel.updateSearch(search);

  ProductsUiState get currentState => viewModel.state.value;
}
