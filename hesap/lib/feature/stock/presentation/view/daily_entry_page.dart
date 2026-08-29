import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_card.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_header.dart';

import '../mixin/daily_entry_page_mixin.dart';
import '../view_model/daily_entry_ui_state.dart';
import '../view_model/daily_entry_view_model.dart';

part 'daily_entry_page_parts.dart';

class DailyEntryPage extends StatefulWidget {
  const DailyEntryPage({
    super.key,
    required this.viewModel,
  });

  /// ViewModel artık dışarıdan (MainNavigation) sağlanıyor.
  /// Bu sayede sekmeler arası geçişte aynı instance korunuyor ve
  /// Ürünler sayfasında yapılan değişiklikler burada da görülebiliyor.
  final DailyEntryViewModel viewModel;

  @override
  State<DailyEntryPage> createState() => _DailyEntryPageState();
}

final class _DailyEntryPageState extends State<DailyEntryPage>
    with DailyEntryPageMixin<DailyEntryPage> {
  // Eskiden burada `buildViewModel()` override edilip yeni bir
  // DailyEntryViewModel inşa ediliyordu. Artık widget.viewModel
  // doğrudan kullanılıyor — bkz. DailyEntryPageMixin.viewModel getter'ı.
  @override
  DailyEntryViewModel get viewModel => widget.viewModel;

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<DailyEntryUiState>(
          valueListenable: viewModel.state,
          builder: (context, state, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DailyEntryHeader(),
                Expanded(child: _buildBody(state)),
                _DailyEntrySaveButton(
                  isSaving: state.isSaving,
                  onPressed: onSaveAll,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Body switch ────────────────────────────────────────────────────────────

  Widget _buildBody(DailyEntryUiState state) {
    if (state.isLoading) return const _DailyEntryLoading();
    if (state.hasError) return _DailyEntryError(message: state.error!);
    if (!state.hasProducts) return const _DailyEntryEmpty();

    return _DailyEntryList(
      state: state,
      controllerFor: controllerFor,
      onQuantityChanged: onQuantityChanged,
    );
  }
}
