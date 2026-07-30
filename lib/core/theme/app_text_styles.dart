import "package:flutter/material.dart";
import "app_colors.dart";

abstract final class HappyTextStyles {
  static const TextTheme lightTextTheme = TextTheme(
    // 大标题：
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.3, // 行高 = fontSize * 1.3
      color: HappyColors.textPrimary,
    ),

    // 正文：
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5,
      color: HappyColors.textPrimary,
    ),

    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      height: 1.4,
      color: HappyColors.textSecondary,
    ),

    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  static const TextTheme darkTextTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.3,
      color: HappyColors.darkTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.5,
      color: HappyColors.darkTextPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 1.4,
      color: HappyColors.darkTextSecondary,
    ),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
}
