import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/app_design_system.dart';
import 'package:hesap/feature/home/presentation/view-model/home_view_model.dart';

import '../../../../core/theme/app_theme_context.dart';
import '../../../../core/widgets/app_gap.dart';
import '../../domain/entities/home_summary.dart';
import '../mixin/home_page_mixin.dart';
import '../state/home_view_state.dart';
import '../widgets/alert_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/product_stock_tile.dart';
import '../widgets/summary_card.dart';
import '../widgets/weekly_chart_card.dart';

part 'parts/home_content.dart';
part 'parts/home_error_view.dart';
part 'parts/home_loading_view.dart';
part 'parts/home_section_title.dart';
part 'parts/home_summary_grid.dart';

final class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.viewModel,
  });

  /// ViewModel artık dışarıdan (MainNavigation) sağlanıyor.
  /// Sekmeler arası geçişte aynı instance korunur, Ürünler/DailyEntry
  /// sayfasında yapılan değişiklikler Home'a da yansır.
  final HomeViewModel viewModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

final class _HomePageState extends State<HomePage> with HomePageMixin {
  @override
  HomeViewModel get viewModel => widget.viewModel;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: ValueListenableBuilder<HomeViewState>(
          valueListenable: viewModel.state,
          builder: (context, state, _) {
            if (state.isInitialOrLoading) {
              return const _HomeLoadingView();
            }
            if (state.isError) {
              return _HomeErrorView(
                message: state.errorMessage ?? '',
                onRetry: onRetryTap,
              );
            }
            return _HomeContent(
              state: state,
              onRefresh: onRefresh,
              onSeeAllProductsTap: onSeeAllProductsTap,
            );
          },
        ),
      ),
    );
  }
}
