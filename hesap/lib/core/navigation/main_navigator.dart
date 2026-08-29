import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/home/domain/usecases/get_home_summary.dart';
import 'package:hesap/feature/home/presentation/view-model/home_view_model.dart';
import 'package:hesap/feature/home/presentation/view/home_page.dart';
import 'package:hesap/feature/reports/domain/usecases/get_report_summary_use_case.dart';
import 'package:hesap/feature/reports/presentation/view/reports_page.dart';
import 'package:hesap/feature/reports/presentation/view_model/reports_view_model.dart';
import 'package:hesap/feature/settings/domain/repositories/settings_repository.dart';
import 'package:hesap/feature/settings/domain/usecases/get_settings.dart';
import 'package:hesap/feature/settings/domain/usecases/save_settings.dart';
import 'package:hesap/feature/settings/presentation/view/settings_page.dart';
import 'package:hesap/feature/settings/presentation/view_model/settings_view_model.dart';
import 'package:hesap/feature/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:hesap/feature/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:hesap/feature/stock/presentation/view/daily_entry_page.dart';
import 'package:hesap/feature/stock/presentation/view_model/daily_entry_view_model.dart';
import 'package:hesap/feature/sub_feature/product/usecases/add_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/delete_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/update_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/view/products_page.dart';
import 'package:hesap/module/csv_export/csv_export_service.dart';
import 'package:hesap/module/notification/notification_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
    // Home
    required this.getHomeSummary,
    // Settings
    required this.getSettings,
    required this.saveSetting,
    required this.settingsRepository,
    required this.notificationService,
    // Products
    required this.getAllProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    // Daily Entry
    required this.saveDailyEntries,
    required this.getLastEntry,
    // Reports
    required this.getReportSummary,
    required this.csvExportService,
  });

  final GetHomeSummary getHomeSummary;

  final GetSettings getSettings;
  final SaveSetting saveSetting;
  final SettingsRepository settingsRepository;
  final NotificationService notificationService;

  final GetAllProductsUseCase getAllProducts;
  final AddProductUseCase addProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProduct;

  final SaveDailyEntriesUseCase saveDailyEntries;
  final GetLastEntryForProductUseCase getLastEntry;

  final GetReportSummaryUseCase getReportSummary;
  final CsvExportService csvExportService;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // ── Sekme indeksleri ────────────────────────────────────────────────────
  static const int _homeIndex = 0;
  static const int _productsIndex = 1;
  static const int _dailyIndex = 2;
  static const int _reportsIndex = 3;
  static const int _settingsIndex = 4;

  // ── ViewModel'ler burada yaşıyor ─────────────────────────────────────────
  // IndexedStack initState'i tab değişiminde tekrar tetiklemediği için tüm
  // ViewModel'ler shell seviyesinde tutulur ve _onTap içinde tazelenir.

  late final DailyEntryViewModel _dailyEntryViewModel = DailyEntryViewModel(
    getAllProducts: widget.getAllProducts,
    saveDailyEntries: widget.saveDailyEntries,
    getLastEntry: widget.getLastEntry,
  )..loadProducts();

  late final HomeViewModel _homeViewModel = HomeViewModel(
    getHomeSummary: widget.getHomeSummary,
  )..loadHome();

  late final ReportsViewModel _reportsViewModel = ReportsViewModel(
    getReportSummary: widget.getReportSummary,
    csvExportService: widget.csvExportService,
  )..load();

  // Settings de aynı desende: DailyEntryViewModel gibi ilk yükleme burada,
  // tab'a her girişte _onTap içinde tazeleniyor.
  late final SettingsViewModel _settingsViewModel = SettingsViewModel(
    getSettings: widget.getSettings,
    saveSetting: widget.saveSetting,
    repository: widget.settingsRepository,
    notificationService: widget.notificationService,
  )..loadSettings();

  void _onTap(int index) {
    setState(() => _currentIndex = index);

    if (index == _dailyIndex) {
      _dailyEntryViewModel.loadProducts();
    }

    if (index == _homeIndex) {
      _homeViewModel.refresh();
    }

    if (index == _reportsIndex) {
      _reportsViewModel.load();
    }

    if (index == _settingsIndex) {
      // DailyEntry'deki loadProducts() ile aynı mantık: tab'a her girişte
      // diskten tekrar oku, başka bir yerden değişmiş olabilecek ayarları
      // yakala. Reports/Home gibi filtre/scroll korunacak bir state yok,
      // bu yüzden ayrı bir refresh() eklemeye gerek görülmedi.
      _settingsViewModel.loadSettings();
    }
  }

  late final List<Widget> _pages = [
    HomePage(viewModel: _homeViewModel),
    ProductsPage(
      getAllProducts: widget.getAllProducts,
      addProduct: widget.addProduct,
      updateProduct: widget.updateProduct,
      deleteProduct: widget.deleteProduct,
    ),
    DailyEntryPage(viewModel: _dailyEntryViewModel),
    ReportsPage(viewModel: _reportsViewModel),
    SettingsPage(viewModel: _settingsViewModel),
  ];

  @override
  void dispose() {
    _dailyEntryViewModel.dispose();
    _homeViewModel.dispose();
    _reportsViewModel.dispose(); // ⚠️ önceden eksikti, ekstra düzeltme
    _settingsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

// ── Bottom navigation bar ──────────────────────────────────────────────────
// (değişmedi)

final class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        border: Border(
          top: BorderSide(color: context.appTheme.divider, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: AppStrings.navHome,
                index: 0,
                current: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.inventory_2_rounded,
                label: AppStrings.navProducts,
                index: 1,
                current: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.edit_note_rounded,
                label: AppStrings.navDaily,
                index: 2,
                current: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: AppStrings.navReports,
                index: 3,
                current: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: AppStrings.navSettings,
                index: 4,
                current: currentIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav item ───────────────────────────────────────────────────────────────
// (değişmedi)

final class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final color = isActive ? context.colors.primary : context.appTheme.muted;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconMd + 2, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(color: color),
            ),
            const SizedBox(height: 3),
            Container(
              width: AppSizes.xs,
              height: AppSizes.xs,
              decoration: BoxDecoration(
                color: isActive ? context.colors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
