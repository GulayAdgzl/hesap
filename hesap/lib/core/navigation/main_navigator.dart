import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/reports/presentation/bloc/reports_cubit.dart';
import 'package:hesap/feature/reports/presentation/pages/reports_page.dart';
import 'package:hesap/feature/settings/presentation/bloc/settings_cubit.dart';
import 'package:hesap/feature/settings/presentation/pages/settings_page.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hesap/feature/stock/presentation/pages/daily_entry_page.dart';
import 'package:hesap/feature/sub_feature/product/pages/products_page.dart';
import 'package:hesap/feature/sub_feature/product/presentation/bloc/product_cubit.dart';
import 'package:hesap/product/initialize/injection_container.dart' as di;

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _onTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ProductCubit>()),
        BlocProvider(create: (_) => di.sl<DailyEntryCubit>()),
        BlocProvider(create: (_) => di.sl<ReportsCubit>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit>()),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            PlaceholderPage(
                label: AppStrings.navHome, icon: Icons.home_rounded),
            ProductsPage(),
            DailyEntryPage(),
            ReportsPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: Color(0xFFEDEAF8), width: 1)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  _NavItem(
                      icon: Icons.home_rounded,
                      label: AppStrings.navHome,
                      index: 0,
                      current: _currentIndex,
                      onTap: _onTap),
                  _NavItem(
                      icon: Icons.inventory_2_rounded,
                      label: AppStrings.navProducts,
                      index: 1,
                      current: _currentIndex,
                      onTap: _onTap),
                  _NavItem(
                      icon: Icons.edit_note_rounded,
                      label: AppStrings.navDaily,
                      index: 2,
                      current: _currentIndex,
                      onTap: _onTap),
                  _NavItem(
                      icon: Icons.bar_chart_rounded,
                      label: AppStrings.navReports,
                      index: 3,
                      current: _currentIndex,
                      onTap: _onTap),
                  _NavItem(
                      icon: Icons.settings_rounded,
                      label: AppStrings.navSettings,
                      index: 4,
                      current: _currentIndex,
                      onTap: _onTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 22,
                color: isActive ? AppColors.primary : AppColors.muted),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.primary : AppColors.muted,
                )),
            const SizedBox(height: 3),
            if (isActive)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String label;
  final IconData icon;
  const PlaceholderPage({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.dark,
                )),
            const SizedBox(height: 6),
            const Text(AppStrings.navComingSoon,
                style: TextStyle(color: AppColors.muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
