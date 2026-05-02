class AppStrings {
  AppStrings._();

  // Genel
  static const appName = 'StokAI';
  static const save = 'Kaydet';
  static const cancel = 'İptal';
  static const delete = 'Sil';
  static const edit = 'Düzenle';
  static const confirm = 'Onayla';

  // Birimler
  static const units = ['kg', 'litre', 'adet', 'gram', 'paket'];

  // Ürünler sayfası
  static const productsTitle = 'Ürünler';
  static const searchHint = 'Ürün ara...';
  static const filterAll = 'Tümü';
  static const filterCritical = 'Kritik';
  static const filterNormal = 'Normal';
  static const filterMostConsumed = 'En Çok Tüketilen';
  static const noProducts = 'Henüz ürün yok';
  static const noProductsHint = '+ butonuna basarak ürün ekle';
  static const noFilterResult = 'için ürün bulunamadı';

  // Ürün ekleme
  static const addProduct = 'Yeni Ürün';
  static const saveProduct = 'Ürünü Kaydet';
  static const productName = 'Ürün Adı *';
  static const productNameHint = 'örn. Un, Şeker, Tereyağ';
  static const productNameRequired = 'Ürün adı zorunludur';
  static const unit = 'Birim';
  static const unitCost = 'Birim Maliyet';
  static const unitCostHint = '₺0.00';
  static const maxStock = 'Maks. Stok';
  static const maxStockHint = '500';
  static const criticalThreshold = 'Kritik Stok Eşiği';
  static const criticalThresholdHint =
      'Stok bu oranın altına düşünce kritik uyarısı verilir';

  // Ürün düzenleme
  static const editProduct = 'Ürünü Düzenle';
  static const saveChanges = 'Değişiklikleri Kaydet';

  // Silme dialog
  static const deleteProduct = 'Ürünü Sil';
  static const deleteConfirm = 'ürününü silmek istediğine emin misin?';
  static const deleteYes = 'Evet, Sil';

  // Stok durumu
  static const statusCritical = 'Kritik!';
  static const statusWarning = 'Dikkat';
  static const statusNormal = 'Normal';
  static const remaining = 'Kalan';
  static const max = 'Max';

  // Günlük Giriş sayfası
  static const dailyEntryTitle = 'Günlük Stok Girişi';
  static const dailyEntrySubtitle =
      'Bugün kalan miktarı gir, tüketim otomatik hesaplanır';
  static const dailyEntrySaveAll = 'Tüm Girişleri Kaydet';
  static const dailyEntrySaved = 'Girişler kaydedildi ✓';
  static const dailyEntryNoValue = 'Lütfen en az bir ürün için değer girin';
  static const yesterdayLabel = 'DÜN KALAN';
  static const todayLabel = 'BUGÜN KALAN *';
  static const consumptionLabel = 'Tüketim';
  static const addedLabel = 'Eklenen';
  static const criticalLabel = '⚠️ Kritik';
  static const noProductsDaily = 'Henüz ürün yok';
  static const noProductsDailyHint = 'Önce Ürünler sayfasından ürün ekle';

  // Navigation
  static const String csvExport = 'CSV Olarak Dışa Aktar';
  static const String exporting = 'Dışa Aktarılıyor...';
  static const navHome = 'Ana Sayfa';
  static const navProducts = 'Ürünler';
  static const navDaily = 'Günlük';
  static const navReports = 'Raporlar';
  static const navSettings = 'Ayarlar';
  static const navComingSoon = 'Yakında eklenecek';

  // Ayarlar sayfası — UI metinleri
  static const settingsTitle = 'Ayarlar';

  static const settingsSectionStock = 'STOK AYARLARI';
  static const settingsKritikStokEsigi = 'Kritik Stok Eşiği';
  static const settingsKritikStokEsigiSubtitle = 'Bu oranın altında uyar';
  static const settingsTahminPeriyodu = 'Tahmin Periyodu';
  static const settingsTahminPeriyoduSubtitle = 'Kaç günlük ortalama alınsın';
  static const settingsTahminPeriyoduSuffix = ' Gün';

  static const settingsSectionNotifications = 'BİLDİRİMLER';
  static const settingsKritikStokBildirimLabel = 'Kritik Stok Bildirimi';
  static const settingsKritikStokBildirimSubtitle =
      'Stok kritik seviyede bildir';
  static const settingsGunlukOzetLabel = 'Günlük Özet';
  static const settingsGunlukOzetSubtitle = 'Her sabah 08:00\'de özet';
  static const settingsUretimTahminiLabel = 'Üretim Tahmini';
  static const settingsUretimTahminiSubtitle = 'Yarın için tahmin bildirimi';

  static const settingsSectionApp = 'UYGULAMA';
  static const settingsKoyuTemaLabel = 'Koyu Tema';
  static const settingsDilLabel = 'Dil';
  static const settingsDilValue = 'Türkçe';

  static const settingsLogout = 'Çıkış Yap';
  static const settingsLogoutConfirmTitle = 'Çıkış Yap';
  static const settingsLogoutConfirmMessage =
      'Hesabından çıkış yapmak istediğine emin misin?';
  static const settingsLogoutConfirm = 'Evet, Çıkış Yap';

  // Ayarlar — Desteklenen Diller
  static const List<String> supportedLanguages = [
    'Türkçe',
    'English',
    'Deutsch',
    'Français',
    'Español',
  ];

  // Ayarlar — SharedPreferences Keys
  static const keyCriticalStockThreshold = 'critical_stock_threshold';
  static const keyForecastPeriod = 'forecast_period';
  static const keyCriticalStockNotification = 'critical_stock_notification';
  static const keyDailySummary = 'daily_summary';
  static const keyProductionForecast = 'production_forecast';
  static const keyDarkMode = 'dark_mode';
  static const keyLanguage = 'language';

  // Ayarlar — Varsayılan Değerler
  static const double defaultCriticalStockThreshold = 15.0; // %15
  static const int defaultForecastPeriod = 7; // 7 gün
  static const bool defaultCriticalStockNotification = true;
  static const bool defaultDailySummary = true;
  static const bool defaultProductionForecast = false;
  static const bool defaultDarkMode = false;
  static const String defaultLanguage = 'Türkçe';
}
