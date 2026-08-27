import 'package:flutter/material.dart';

/// utility class to define the app colors

class AppColor {
  /// Primary Theme Colors
  static const Color primary = Color(0xFFFF7A00);
  static const Color primaryDark = Color(0xFFE66A00);
  static const Color primaryLight = Color(0xFFFFA64D);
  static const Color primaryLight2 = Color (0xFFFF8A50);

  /// Accent
  static const Color secondary = Color(0xFFFFB347);
  static const Color orangeTint = Color(0xFFFFE0CC);
  static const Color orangeTint2 = Color(0xFFFFEAD9);

  /// Backgrounds
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFF7F0);
  static const Color whiteDark = Color(0xFFFFFCF8);
  static const Color whiteShade = Color(0xFFFFFAF5);

  /// Text
  static const Color grey = Colors.grey;
  static const Color slateGrey = Color(0xFF7A869A);
  static const Color charcoal = Color(0xFF2E3E5C);
  static const Color black = Color(0xFF232323);
  static const Color textPrimary = Color(0xFF2B2B2B);
  static const Color textSecondary = Color(0xFF6F6F6F);

  /// Borders
  static const Color border = Color(0xFFFFDFC2);

  /// Disabled
  static const Color gray = Color(0xFFBDBDBD);

  /// Extra Theme Colors
  static const Color card = Colors.white;
  static const Color icon = Color(0xFFFF7A00);
  static const Color darkOrange = Color(0xFFFA6624);

  ///app api calls success and failure toast colors
  static const bright_red = Color(0xFFE62222);
  static const green = Color(0xFF188510);

  /// Order Status Specific Colors & Backgrounds
  static const Color statusPending = Color(0xFFD97706);
  static const Color statusPendingBg = Color(0xFFFEF3C7);

  static const Color statusConfirmed = Color(0xFF2563EB);
  static const Color statusConfirmedBg = Color(0xFFDBEAFE);

  static const Color statusPreparing = Color(0xFFEA580C);
  static const Color statusPreparingBg = Color(0xFFFFEDD5);

  static const Color statusReady = Color(0xFF0D9488);
  static const Color statusReadyBg = Color(0xFFCCFBF1);

  static const Color statusDispatched = Color(0xFF7C3AED);
  static const Color statusDispatchedBg = Color(0xFFEDE9FE);

  static const Color statusDelivered = Color(0xFF16A34A);
  static const Color statusDeliveredBg = Color(0xFFDCFCE7);

  static const Color statusCancelled = Color(0xFFDC2626);
  static const Color statusCancelledBg = Color(0xFFFEE2E2);
}
