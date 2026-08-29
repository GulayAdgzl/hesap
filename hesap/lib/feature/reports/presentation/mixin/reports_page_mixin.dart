import 'package:flutter/material.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';

import '../view_model/reports_ui_state.dart';
import '../view_model/reports_view_model.dart';

mixin ReportsPageMixin<T extends StatefulWidget> on State<T> {
  ReportsViewModel get viewModel;

  @override
  void initState() {
    super.initState();
    // Eskiden burada `viewModel = buildViewModel()..load();` vardı.
    // Artık instance widget.viewModel'den geliyor; ilk yükleme
    // MainNavigation tarafından zaten tetiklenmiş olacak. Defensive olarak
    // hiç veri yoksa yükle:
    if (viewModel.state.value.summary == null) {
      viewModel.load();
    }
    viewModel.state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    viewModel.state.removeListener(_onStateChanged);
    // dispose(viewModel) artık YOK — ömrü MainNavigation'a ait.
    super.dispose();
  }

  // ── UI Aksiyonları ─────────────────────────────────────────────────────────

  void onFilterChanged(ReportFilter filter) => viewModel.changeFilter(filter);

  void onExportCsv() => viewModel.exportCsv();

  // ── State dinleyici ────────────────────────────────────────────────────────

  void _onStateChanged() {
    final s = viewModel.state.value;
    if (s.hasError && mounted) {
      _showErrorSnackBar(s.error!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) viewModel.state.value = s.copyWith(clearError: true);
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Mevcut state'i kısayol olarak sunar.
  ReportsUiState get currentState => viewModel.state.value;
}
