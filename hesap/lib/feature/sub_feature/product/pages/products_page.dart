import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/pages/edit_product_sheet.dart';
import 'package:hesap/feature/sub_feature/product/pages/product_filter.dart';

import '../../../../product/widget/product_card.dart';
import '../presentation/bloc/product_cubit.dart';
import '../presentation/bloc/product_state.dart';
import 'add_product_sheet.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _filter = AppStrings.filterAll;
  String _search = '';
  final _filters = [
    AppStrings.filterAll,
    AppStrings.filterCritical,
    AppStrings.filterNormal,
    AppStrings.filterMostConsumed,
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  List<Product> _applyFilter(List<Product> products) {
    List<Product> result = products;

    if (_search.isNotEmpty) {
      result = result
          .where((p) => p.name.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }

    switch (_filter) {
      case AppStrings.filterCritical:
        result = result.where((p) {
          final ratio = p.quantity / 500;
          return ratio <= (p.criticalThreshold / 100);
        }).toList();
        break;
      case AppStrings.filterNormal:
        result = result.where((p) {
          final ratio = p.quantity / 500;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(AppStrings.productsTitle,
                  style: AppTextStyles.pageTitle),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.muted, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        decoration: const InputDecoration(
                          hintText: AppStrings.searchHint,
                          hintStyle:
                              TextStyle(color: AppColors.muted, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final selected = f == _filter;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.inputBorder,
                        ),
                      ),
                      child: Text(
                        f,
                        style: AppTextStyles.chipText.copyWith(
                          color: selected ? Colors.white : AppColors.muted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Product List
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductStateLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state is ProductStateError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    );
                  }

                  if (state is ProductStateLoaded) {
                    final filtered = ProductFilter.apply(
                      products: state.products,
                      filter: _filter,
                      search: _search,
                    );

                    if (state.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('📦', style: TextStyle(fontSize: 48)),
                            SizedBox(height: 12),
                            Text(
                              AppStrings.noProducts,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              AppStrings.noProductsHint,
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      );
                    }

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🔍', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              '"$_filter" ${AppStrings.noFilterResult}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) => ProductCard(
                        product: filtered[i],
                        onEdit: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProductCubit>(),
                            child: EditProductSheet(product: filtered[i]),
                          ),
                        ),
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text(
                                AppStrings.deleteProduct,
                                style: TextStyle(
                                  fontFamily: 'Syne',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              content: Text(
                                '"${filtered[i].name}" ${AppStrings.deleteConfirm}',
                                style: AppTextStyles.caption
                                    .copyWith(fontSize: 13),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text(
                                    AppStrings.cancel,
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text(
                                    AppStrings.deleteYes,
                                    style: TextStyle(
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && context.mounted) {
                            context
                                .read<ProductCubit>()
                                .deleteProduct(filtered[i].id);
                          }
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: context.read<ProductCubit>(),
            child: const AddProductSheet(),
          ),
        ),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
