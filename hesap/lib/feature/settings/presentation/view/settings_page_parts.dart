part of 'settings_page.dart';

// ── Section wrapper ────────────────────────────────────────────────────────

final class _SectionWrapper extends StatelessWidget {
  const _SectionWrapper({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(title: title),
          const SizedBox(height: AppSizes.sm),
          Container(
            decoration: BoxDecoration(
              color: context.appTheme.cardBackground,
              borderRadius: AppRadius.baseBorderRadius,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ── Row ayracı ─────────────────────────────────────────────────────────────

final class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.appTheme.divider,
      indent: AppSizes.xxl + AppSizes.xl, // icon box + gap ≈ 56 px
    );
  }
}

// ── Logout butonu ──────────────────────────────────────────────────────────

final class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.base),
          decoration: BoxDecoration(
            color: context.appTheme.dangerContainer,
            borderRadius: AppRadius.baseBorderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: context.appTheme.danger,
                size: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                AppStrings.settingsLogout,
                style: context.textTheme.labelLarge
                    ?.copyWith(color: context.appTheme.danger),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hata durumu ────────────────────────────────────────────────────────────

final class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.appTheme.muted),
          ),
          const SizedBox(height: AppSizes.md),
          TextButton(
            onPressed: onRetry,
            child: Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
