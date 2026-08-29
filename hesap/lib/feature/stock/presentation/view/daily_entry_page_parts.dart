part of 'daily_entry_page.dart';

// ── Yükleniyor ─────────────────────────────────────────────────────────────

final class _DailyEntryLoading extends StatelessWidget {
  const _DailyEntryLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.colors.primary),
    );
  }
}

// ── Hata ──────────────────────────────────────────────────────────────────

final class _DailyEntryError extends StatelessWidget {
  const _DailyEntryError({required this.message});

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

final class _DailyEntryEmpty extends StatelessWidget {
  const _DailyEntryEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: AppSizes.huge,
            color: context.appTheme.muted,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            AppStrings.noProductsDaily,
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.noProductsDailyHint,
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.appTheme.muted),
          ),
        ],
      ),
    );
  }
}

// ── Ürün listesi ───────────────────────────────────────────────────────────

final class _DailyEntryList extends StatelessWidget {
  const _DailyEntryList({
    required this.state,
    required this.controllerFor,
    required this.onQuantityChanged,
  });

  final DailyEntryUiState state;
  final TextEditingController Function(String) controllerFor;
  final void Function(String productId, String raw) onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.base,
      ),
      itemCount: state.products.length,
      itemBuilder: (context, i) {
        final product = state.products[i];
        return DailyEntryCard(
          product: product,
          lastEntry: state.lastEntries[product.id],
          controller: controllerFor(product.id),
          onChanged: (val) => onQuantityChanged(product.id, val),
        );
      },
    );
  }
}

// ── Kaydet butonu ──────────────────────────────────────────────────────────

final class _DailyEntrySaveButton extends StatelessWidget {
  const _DailyEntrySaveButton({
    required this.isSaving,
    required this.onPressed,
  });

  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        0,
        AppSizes.lg,
        AppSizes.md,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isSaving ? null : onPressed,
          icon: isSaving
              ? SizedBox(
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.onPrimary,
                  ),
                )
              : Icon(
                  Icons.save_rounded,
                  color: context.colors.onPrimary,
                  size: AppSizes.iconMd - 2,
                ),
          label: Text(
            AppStrings.dailyEntrySaveAll,
            style: context.textTheme.labelLarge
                ?.copyWith(color: context.colors.onPrimary),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.md + 3),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.baseBorderRadius,
            ),
          ),
        ),
      ),
    );
  }
}
