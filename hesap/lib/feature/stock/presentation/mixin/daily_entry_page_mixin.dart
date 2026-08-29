import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

import '../view_model/daily_entry_ui_state.dart';
import '../view_model/daily_entry_view_model.dart';

mixin DailyEntryPageMixin<T extends StatefulWidget> on State<T> {
  DailyEntryViewModel get viewModel;

  // TextEditingController havuzu — her ürün ID'si için bir controller.
  final Map<String, TextEditingController> _controllers = {};

  // ── Yaşam döngüsü ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    viewModel.state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    viewModel.state.removeListener(_onStateChanged);

    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  // ── Controller fabrikası ───────────────────────────────────────────────────

  /// Her ürün için aynı controller'ı döndürür; yoksa oluşturur.
  TextEditingController controllerFor(String productId) =>
      _controllers.putIfAbsent(productId, () => TextEditingController());

  // ── State dinleyici ────────────────────────────────────────────────────────

  void _onStateChanged() {
    final s = viewModel.state.value;
    if (!mounted) return;

    if (s.savedSuccessfully) {
      _showSuccessSnackbar();
      // Girilen değerleri temizle ki yeni güne hazır olsun.
      for (final c in _controllers.values) {
        c.clear();
      }
      // Sinyali temizle ve ürünleri yeniden yükle.
      viewModel.state.value = viewModel.state.value.copyWith(clearSaved: true);
      viewModel.loadProducts();
      return;
    }

    if (s.hasError) {
      _showErrorSnackbar(s.error!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          viewModel.state.value =
              viewModel.state.value.copyWith(clearError: true);
        }
      });
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppStrings.dailyEntrySaved),
        backgroundColor: context.appTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.mdBorderRadius,
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.appTheme.danger,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.mdBorderRadius,
        ),
      ),
    );
  }

  // ── Aksiyonlar ─────────────────────────────────────────────────────────────

  void onQuantityChanged(String productId, String raw) =>
      viewModel.updateQuantity(productId, int.tryParse(raw));

  void onSaveAll() => viewModel.saveAll();

  // ── Kolay erişim ──────────────────────────────────────────────────────────

  DailyEntryUiState get currentState => viewModel.state.value;
}
