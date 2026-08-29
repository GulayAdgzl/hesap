/// Tema sisteminin tek giriş noktası.
///
/// Projenin her yerinde:
/// ```dart
/// import 'package:hesap/core/theme/theme.dart';
/// ```
library;

export 'app_colors.dart';
export 'app_design_system.dart';
export 'app_theme.dart';
export 'app_theme_extension.dart';

import 'package:flutter/material.dart';
import 'app_theme_extension.dart';

/// [BuildContext] üzerinden tema tokenlarına hızlı erişim.
///
/// ```dart
/// // Renk tokenı
/// Container(color: context.appTheme.cardBackground);
///
/// // Material ColorScheme
/// Text('...', style: TextStyle(color: context.colors.primary));
///
/// // Metin stili
/// Text('Başlık', style: context.textTheme.titleLarge);
/// ```
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