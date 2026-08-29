import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_filter_bar.dart';

import '../mixin/reports_page_mixin.dart';
import '../view_model/reports_ui_state.dart';
import '../view_model/reports_view_model.dart';
import '../widgets/reports_content.dart';
import '../widgets/reports_header.dart';

part 'reports_page_error.dart';
part 'reports_page_loading.dart';

final class ReportsPage extends StatefulWidget {
  const ReportsPage({
    super.key,
    required this.viewModel,
  });

  /// ViewModel artık dışarıdan (MainNavigation) sağlanıyor.
  /// Böylece sekmeler arası geçişte aynı instance korunur ve filtre/veri
  /// state'i kaybolmaz.
  final ReportsViewModel viewModel;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

final class _ReportsPageState extends State<ReportsPage>
    with ReportsPageMixin<ReportsPage> {
  @override
  ReportsViewModel get viewModel => widget.viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<ReportsUiState>(
          valueListenable: viewModel.state,
          builder: (context, state, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReportsHeader(
                  isExporting: state.isExporting,
                  onExport: onExportCsv,
                ),
                ReportsFilterBar(
                  filter: state.filter,
                  onChanged: onFilterChanged,
                ),
                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(ReportsUiState state) {
    if (state.isLoading) return const _ReportsPageLoading();
    if (state.hasError) return _ReportsPageError(message: state.error!);
    if (state.hasData) return ReportsContent(state: state);
    return const SizedBox.shrink();
  }
}
