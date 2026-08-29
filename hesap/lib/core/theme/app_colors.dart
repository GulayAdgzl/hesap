import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7C6FF7);
  static const Color primaryLight = Color(0xFFEAE8FD);

  // ── Nötr / Zemin ───────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF4F2EE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color dark = Color(0xFF1A1A2E);
  static const Color muted = Color(0xFF9090A8);

  // ── Input ──────────────────────────────────────────────────────────────────
  static const Color inputBorder = Color(0xFFEAE8FD);
  static const Color inputFill = Color(0xFFF8F7FC);
  static const Color inputHint = Color(0xFFC0BDD8);
  static const Color handle = Color(0xFFE0DEF0);

  // ── Durum renkleri ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF5CC8A0);
  static const Color successLight = Color(0xFFE8FDF4);
  static const Color warning = Color(0xFFF5A623);
  static const Color warningLight = Color(0xFFFFF5E6);
  static const Color danger = Color(0xFFF76F6F);
  static const Color dangerLight = Color(0xFFFFE8E8);

  // ── Settings ───────────────────────────────────────────────────────────────
  static const Color settingsSectionLabel = Color(0xFF9090A8);
  static const Color settingsDivider = Color(0xFFF0EEF8);
  static const Color settingsToggleActive = Color(0xFF7C6FF7);
  static const Color settingsLogoutText = Color(0xFFF76F6F);
  static const Color settingsLogoutBg = Color(0xFFFFE8E8);
  static const Color settingsRowBg = Color(0xFFFFFFFF);
  static const Color settingsChevron = Color(0xFFC0BDD8);

  // ── Dark-mode primitifleri ─────────────────────────────────────────────────
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkBackground = Color(0xFF12121C);
  static const Color darkTrack = Color(0xFF2E2E4E);
  static const Color darkTrackSelected = Color(0xFF2E2E5E);
  static const Color darkThumbOff = Color(0xFF6E6E8E);
  static const Color darkSwitchTrackOff = Color(0xFF2A2A3A);
  static const Color darkDivider = Color(0xFF2E2E4E);

  // ── Shimmer ────────────────────────────────────────────────────────────────
  static const Color shimmerBaseLigh = Color(0xFFE8E6F0);
  static const Color shimmerHighlightLight = Color(0xFFF8F7FC);
  static const Color shimmerBaseDark = Color(0xFF2A2A3A);
  static const Color shimmerHighlightDark = Color(0xFF3A3A4E);
}
