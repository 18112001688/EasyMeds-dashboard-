import 'package:flutter/material.dart';
import 'package:medcs_dashboard/core/constant/colors.dart';

class ThemeManager {
  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.scaffoldLightMode,
      appBarTheme: const AppBarTheme(
        color: AppColors.scaffoldLightMode,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.scaffoldDarkMode,
      appBarTheme: const AppBarTheme(
        color: AppColors.scaffoldDarkMode,
      ),
      iconTheme: const IconThemeData(color: AppColors.secondryLight),
    );
  }
}
