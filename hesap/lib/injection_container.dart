import 'package:get_it/get_it.dart';
import 'package:hesap/features/product/presentation/bloc/product_cubit.dart';
import 'package:hesap/features/reports/data/datasources/reports_local_datasource.dart';
import 'package:hesap/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:hesap/features/reports/data/services/csv_export_service.dart';
import 'package:hesap/features/reports/domain/repositories/reports_repository.dart';
import 'package:hesap/features/reports/domain/usecases/get_report_summary.dart';
import 'package:hesap/features/reports/domain/usecases/get_top_consumed.dart';
import 'package:hesap/features/reports/presentation/bloc/reports_cubit.dart';
import 'package:hesap/features/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:hesap/features/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:hesap/features/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hive_ce/hive.dart';
import 'package:hesap/core/models/daily_stock_entry_model.dart';
import 'package:hesap/core/models/product_model.dart';
import 'package:hesap/features/product/data/datasources/product_local_datasource.dart';
import 'package:hesap/features/product/data/repositories/product_repository_impl.dart';
import 'package:hesap/features/product/domain/repositories/product_repository.dart';
import 'package:hesap/features/product/domain/usecases/add_product_usecase.dart';
import 'package:hesap/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:hesap/features/product/domain/usecases/get_all_products_usecase.dart';
import 'package:hesap/features/product/domain/usecases/update_product_usecase.dart';
import 'package:hesap/features/stock/data/datasources/daily_entry_datasource.dart';
import 'package:hesap/features/stock/data/repositories/daily_entry_repository_impl.dart';
import 'package:hesap/features/stock/domain/repositories/daily_entry_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Hive Boxes ────────────────────────────────────────────────────────────
  final productBox = await Hive.openBox<ProductModel>('products');
  final entryBox = await Hive.openBox<DailyStockEntryModel>('daily_entries');

  // ── Product ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProductLocalDatasource>(
    () => ProductLocalDatasourceImpl(productBox),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => GetAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerFactory(() => ProductCubit(
        addProductUseCase: sl(),
        getAllProductsUseCase: sl(),
        updateProductUseCase: sl(),
        deleteProductUseCase: sl(),
      ));

  // ── Stock ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DailyEntryLocalDatasource>(
    () => DailyEntryLocalDatasourceImpl(entryBox),
  );
  sl.registerLazySingleton<DailyEntryRepository>(
    () => DailyEntryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SaveDailyEntriesUseCase(sl()));
  sl.registerLazySingleton(() => GetLastEntryForProductUseCase(sl()));
  sl.registerFactory(() => DailyEntryCubit(
        getAllProductsUseCase: sl(),
        saveDailyEntriesUseCase: sl(),
        getLastEntryForProductUseCase: sl(),
      ));

  // ── Reports ───────────────────────────────────────────────────────────────
  // Datasource: mevcut entryBox'ı tekrar kullanır, yeni box açmaz
  sl.registerLazySingleton<ReportsLocalDatasource>(
    () => ReportsLocalDatasourceImpl(entryBox),
  );
  sl.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetReportSummary(sl()));
  sl.registerLazySingleton(() => GetTopConsumed(sl()));
  sl.registerLazySingleton(() => CsvExportService());
  sl.registerFactory(() => ReportsCubit(
        getReportSummary: sl(),
        getTopConsumed: sl(),
        csvExportService: sl(),
      ));
}