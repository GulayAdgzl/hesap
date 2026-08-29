import 'package:flutter/material.dart';

import 'app_theme_context.dart';

/// Projenin tipografi rehberi.
///
/// TextTheme slot → kullanım amacı eşleştirmesi:
/// ```
/// titleLarge   (Syne 22 w700) → Sayfa başlığı
/// titleMedium  (Syne 16 w700) → Sheet / dialog başlığı
/// titleSmall   (Syne 14 w700) → Kart / section başlığı
/// labelLarge   (Syne 14 w700) → Ürün adı, buton metni
/// labelMedium  (Syne 12 w600) → Chip, form label
/// labelSmall   (Syne 11 w600) → Badge, kritik etiketi
/// bodyMedium   (sys  14 w400) → Standart paragraf
/// bodySmall    (sys  12 w400) → Meta bilgi, caption
/// headlineSmall(Syne 24 w700) → Büyük sayısal değer
/// ```
abstract final class AppTypography {
  AppTypography._();
  static const String syne = 'Syne';
}

// ── Varyant tipi (dosya içi, private) ─────────────────────────────────────

enum _AppTextVariant {
  h1,
  h2,
  h3,
  label,
  chip,
  badge,
  body,
  caption,
  quantity,
}

/// Metin kullanımını standartlaştıran yardımcı widget.
///
/// `style` parametresi içeride otomatik set edilir.
///
/// ```dart
/// AppText.h1('Raporlar')
/// AppText.h3('En Çok Tüketilen')
/// AppText.quantity('₺1.240', color: context.appTheme.success)
/// AppText.caption('Bu hafta', color: context.appTheme.muted)
/// AppText.badge('Kritik!', color: context.appTheme.danger)
/// ```
class AppText extends StatelessWidget {
  // Dahili constructor — varyant positional olarak geçirilir,
  // private-named-parameters deneysel özelliğine gerek kalmaz.
  const AppText._internal(
    this._variant,
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  // ── Fabrika constructor'ları ───────────────────────────────────────────────

  /// Sayfa başlığı — `titleLarge` (Syne 22 w700)
  factory AppText.h1(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
  }) =>
      AppText._internal(_AppTextVariant.h1, text,
          key: key, color: color, textAlign: textAlign);

  /// Sheet / dialog başlığı — `titleMedium` (Syne 16 w700)
  factory AppText.h2(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
  }) =>
      AppText._internal(_AppTextVariant.h2, text,
          key: key, color: color, textAlign: textAlign);

  /// Kart / section başlığı — `titleSmall` (Syne 14 w700)
  factory AppText.h3(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
  }) =>
      AppText._internal(_AppTextVariant.h3, text,
          key: key, color: color, textAlign: textAlign);

  /// Ürün adı, önemli etiket — `labelLarge` (Syne 14 w700)
  factory AppText.label(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
  }) =>
      AppText._internal(_AppTextVariant.label, text,
          key: key, color: color, fontWeight: fontWeight);

  /// Chip, form label — `labelMedium` (Syne 12 w600)
  factory AppText.chip(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
  }) =>
      AppText._internal(_AppTextVariant.chip, text,
          key: key, color: color, fontWeight: fontWeight);

  /// Badge, kritik etiketi — `labelSmall` (Syne 11 w600)
  factory AppText.badge(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
  }) =>
      AppText._internal(_AppTextVariant.badge, text,
          key: key, color: color, fontWeight: fontWeight);

  /// Standart paragraf — `bodyMedium` (sys 14 w400)
  factory AppText.body(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) =>
      AppText._internal(_AppTextVariant.body, text,
          key: key,
          color: color,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines);

  /// Meta bilgi, yardımcı metin — `bodySmall` (sys 12 w400)
  factory AppText.caption(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
  }) =>
      AppText._internal(_AppTextVariant.caption, text,
          key: key, color: color, textAlign: textAlign, overflow: overflow);

  /// Büyük sayısal değer — `headlineSmall` (Syne 24 w700)
  factory AppText.quantity(
    String text, {
    Key? key,
    Color? color,
  }) =>
      AppText._internal(_AppTextVariant.quantity, text, key: key, color: color);

  // ── Fields ────────────────────────────────────────────────────────────────

  final _AppTextVariant _variant;
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final base = _baseStyle(context);
    final resolved = (color != null || fontWeight != null || fontSize != null)
        ? base?.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
          )
        : base;

    return Text(
      text,
      style: resolved,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  TextStyle? _baseStyle(BuildContext context) {
    return switch (_variant) {
      _AppTextVariant.h1 => context.textTheme.titleLarge,
      _AppTextVariant.h2 => context.textTheme.titleMedium,
      _AppTextVariant.h3 => context.textTheme.titleSmall,
      _AppTextVariant.label => context.textTheme.labelLarge,
      _AppTextVariant.chip => context.textTheme.labelMedium,
      _AppTextVariant.badge => context.textTheme.labelSmall,
      _AppTextVariant.body => context.textTheme.bodyMedium,
      _AppTextVariant.caption => context.textTheme.bodySmall,
      _AppTextVariant.quantity => context.textTheme.headlineSmall,
    };
  }
}
