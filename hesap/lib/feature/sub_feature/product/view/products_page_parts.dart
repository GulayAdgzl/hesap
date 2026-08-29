part of 'products_page.dart';

// ── Arama kutusu ───────────────────────────────────────────────────────────

final class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md + 2,
          vertical: AppSizes.md,
        ),
        decoration: BoxDecoration(
          color: context.appTheme.cardBackground,
          borderRadius: AppRadius.mdBorderRadius,
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withOpacity(0.08),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search,
                color: context.appTheme.muted, size: AppSizes.iconMd - 2),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: context.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: context.appTheme.muted,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filtre chip listesi ────────────────────────────────────────────────────

final class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.xxxl,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, i) {
          final f = filters[i];
          final isSelected = f == selected;
          return GestureDetector(
            onTap: () => onChanged(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.base,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.primary
                    : context.appTheme.cardBackground,
                borderRadius: AppRadius.fullBorderRadius,
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : context.appTheme.divider,
                ),
              ),
              child: Text(
                f,
                style: context.textTheme.labelMedium?.copyWith(
                  color: isSelected ? Colors.white : context.appTheme.muted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Yükleniyor ─────────────────────────────────────────────────────────────

final class _ProductsLoading extends StatelessWidget {
  const _ProductsLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.colors.primary),
    );
  }
}

// ── Hata ──────────────────────────────────────────────────────────────────

final class _ProductsError extends StatelessWidget {
  const _ProductsError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.textTheme.bodyMedium
            ?.copyWith(color: context.appTheme.danger),
      ),
    );
  }
}

// ── Boş liste ──────────────────────────────────────────────────────────────

final class _ProductsEmpty extends StatelessWidget {
  const _ProductsEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📦', style: TextStyle(fontSize: 48)),
          const SizedBox(height: AppSizes.md),
          Text(AppStrings.noProducts, style: context.textTheme.titleSmall),
          const SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.noProductsHint,
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.appTheme.muted),
          ),
        ],
      ),
    );
  }
}

// ── Filtre sonucu boş ──────────────────────────────────────────────────────

final class _ProductsFilterEmpty extends StatelessWidget {
  const _ProductsFilterEmpty({required this.filter});

  final String filter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 40)),
          const SizedBox(height: AppSizes.md),
          Text(
            '"$filter" ${AppStrings.noFilterResult}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.appTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ürün listesi ───────────────────────────────────────────────────────────

final class _ProductsList extends StatelessWidget {
  const _ProductsList({
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Product> products;
  final void Function(Product) onEdit;
  final void Function(Product) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: products.length,
      itemBuilder: (context, i) => ProductCard(
        product: products[i],
        onEdit: () => onEdit(products[i]),
        onDelete: () => onDelete(products[i]),
      ),
    );
  }
}
