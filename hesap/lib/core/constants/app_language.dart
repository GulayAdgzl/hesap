enum AppLanguage {
  turkish('tr', 'Türkçe', '🇹🇷'),
  english('en', 'English', '🇬🇧'),
  german('de', 'Deutsch', '🇩🇪'),
  french('fr', 'Français', '🇫🇷'),
  spanish('es', 'Español', '🇪🇸');

  const AppLanguage(this.code, this.label, this.flag);

  /// Persist edilen, kararlı locale kodu. Asla değişmemeli.
  final String code;

  /// Kullanıcıya gösterilen isim. Çeviri/değişiklik burada serbest.
  final String label;

  final String flag;

  static AppLanguage fromCode(String code) => values.firstWhere(
        (lang) => lang.code == code,
        orElse: () => AppLanguage.turkish,
      );
}
