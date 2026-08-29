import 'package:flutter/material.dart';
import 'package:hesap/feature/home/presentation/state/home_view_state.dart';
import 'package:hesap/feature/home/presentation/view-model/home_view_model.dart';

import '../view/home_page.dart';

mixin HomePageMixin on State<HomePage> {
  HomeViewModel get viewModel;

  @override
  void initState() {
    super.initState();

    if (viewModel.state.value.status == HomeViewStatus.initial) {
      viewModel.loadHome();
    }
  }

  @override
  void dispose() {
    // dispose artık burada YOK — ViewModel'in ömrü MainNavigation'a ait.
    super.dispose();
  }

  Future<void> onRefresh() => viewModel.refresh();

  void onRetryTap() => viewModel.loadHome();

  void onSeeAllProductsTap() {
    // TODO: tüm ürün stokları listesi sayfasına yönlendirme eklenecek.
  }
}
