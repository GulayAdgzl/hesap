import 'package:flutter/material.dart';

import 'app_theme_extension.dart';

extension AppThemeContext on BuildContext {
  /// Özel [AppThemeExtension] tokenlarına erişim.
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;

  /// Material 3 [ColorScheme]'e erişim.
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// [TextTheme]'e erişim.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Mevcut tema dark mı?
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
