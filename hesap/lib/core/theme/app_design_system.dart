import 'package:flutter/material.dart';

abstract final class AppSizes {
  AppSizes._();

  // ── Spacing ────────────────────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
  static const double giant = 64;

  // ── Icon sizes ─────────────────────────────────────────────────────────────
  static const double iconXs = 12;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconBase = 24;
  static const double iconLg = 28;
  static const double iconXl = 32;
  static const double iconHuge = 48;

  // ── Avatar / Image ─────────────────────────────────────────────────────────
  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 56;
  static const double avatarXl = 80;

  // ── Button height ──────────────────────────────────────────────────────────
  static const double buttonSm = 36;
  static const double buttonMd = 44;
  static const double buttonLg = 52;

  // ── Input ──────────────────────────────────────────────────────────────────
  static const double inputHeight = 52;
  static const double inputHeightSm = 44;

  // ── Elevation / Border ─────────────────────────────────────────────────────
  static const double borderWidth = 1;
  static const double borderWidthThick = 2;
}

/// Standart köşe yarıçapları — tüm Card, Button, Input vs. için.
abstract final class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double full = 999;

  // ── BorderRadius ───────────────────────────────────────────────────────────
  static const BorderRadius xsBorderRadius =
      BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smBorderRadius =
      BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdBorderRadius =
      BorderRadius.all(Radius.circular(md));
  static const BorderRadius baseBorderRadius =
      BorderRadius.all(Radius.circular(base));
  static const BorderRadius lgBorderRadius =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlBorderRadius =
      BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullBorderRadius =
      BorderRadius.all(Radius.circular(full));
}

/// Merkezi padding tanımları — sayfa ve bileşen kenar boşlukları.
abstract final class AppPadding {
  AppPadding._();

  /// Sayfaların yatay kenar boşluğu (16 px).
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: AppSizes.base);

  /// Sayfa yatay + dikey boşluk (16 px her yön).
  static const EdgeInsets pageAll = EdgeInsets.all(AppSizes.base);

  /// Card / tile iç boşluğu.
  static const EdgeInsets cardPadding = EdgeInsets.all(AppSizes.base);

  /// Dar Card iç boşluğu.
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(AppSizes.sm);

  /// Geniş sayfa kenar boşluğu (24 px).
  static const EdgeInsets pagePaddingLg =
      EdgeInsets.symmetric(horizontal: AppSizes.xl);

  /// Input alanı iç boşluğu.
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: AppSizes.base,
    vertical: AppSizes.md,
  );

  /// Button iç boşluğu.
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSizes.xl,
    vertical: AppSizes.md,
  );

  /// Section başlığı üst boşluğu.
  static const EdgeInsets sectionHeader = EdgeInsets.only(
    left: AppSizes.base,
    right: AppSizes.base,
    top: AppSizes.xl,
    bottom: AppSizes.sm,
  );
}
