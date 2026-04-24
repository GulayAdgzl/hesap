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

// Mevcut dosyaya şunları ekle:

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
}
