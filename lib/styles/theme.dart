import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

/// Light Theme Configuration
ThemeData lightTheme(Color primaryColor) {
  return ThemeData(
    brightness: Brightness.light,

    // Primary Color
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light),

    // Background and Scaffold Colors
    scaffoldBackgroundColor: AppColors.pageBackground,

    // Text Themes
    textTheme: TextTheme(
      displayLarge: AppTypography.title,
      bodyLarge: AppTypography.body,
      labelLarge: AppTypography.button,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.background,
      dividerColor: AppColors.primary,
    ),

    dividerTheme: DividerThemeData(
        color: AppColors.pageBackgroundDark
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      titleTextStyle: AppTypography.title.copyWith(
          color: AppColors.textPrimary),
      iconTheme: IconThemeData(color: AppColors.textSecondary),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s, vertical: AppSpacing.xs),
        textStyle: AppTypography.button,
        foregroundColor: AppColors.textPrimaryDark,
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
    ),

    // Input Decoration Theme (For text fields)
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
      hintStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
    ),

    // Switch Theme (Custom switch style)
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary),
      trackColor: WidgetStateProperty.all(
          AppColors.primary.withAlpha(76)), // 0.3 opacity
    ),

    // Slider Theme (Custom slider style)
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.primary.withAlpha(76),
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withAlpha(51),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedIconTheme: IconThemeData(color: AppColors.primary),
      unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surface,
      titleTextStyle: AppTypography.title.copyWith(color: AppColors.textPrimary),
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.l),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.button,
      ),
    ),

    dividerColor: AppColors.background,

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.textPrimaryDark),
      actionTextColor: AppColors.textPrimaryDark,
    ),

    // Use Material 3 design principles
    useMaterial3: true,
  );
}

/// Dark Theme Configuration
ThemeData darkTheme(Color primaryColor) {
  return ThemeData(
    brightness: Brightness.dark,

    // Primary Color
    primaryColorLight: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),

    // Background and Scaffold Colors
    scaffoldBackgroundColor: AppColors.pageBackgroundDark,

    // Text Themes
    textTheme: TextTheme(
      displayLarge: AppTypography.title.copyWith(color: AppColors.textPrimaryDark),
      bodyLarge: AppTypography.body.copyWith(color: AppColors.textPrimaryDark),
      labelLarge: AppTypography.button.copyWith(color: AppColors.textPrimaryDark),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.backgroundDark,
      dividerColor: AppColors.primary,
    ),

    dividerTheme: DividerThemeData(
        color: AppColors.pageBackground
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      titleTextStyle: AppTypography.title.copyWith(
          color: AppColors.textPrimaryDark),
      iconTheme: IconThemeData(color: AppColors.textSecondaryDark),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s, vertical: AppSpacing.xs),
        textStyle: AppTypography.button,
        foregroundColor: AppColors.textPrimaryDark,
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 6,
    ),

    // Input Decoration Theme (For text fields)
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: AppTypography.body.copyWith(color: AppColors.textSecondaryDark),
      hintStyle: AppTypography.body.copyWith(color: AppColors.textSecondaryDark),
    ),

    // Switch Theme (Custom switch style)
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary),
      trackColor: WidgetStateProperty.all(AppColors.primary.withAlpha(76)), // 0.3 opacity
    ),

    // Slider Theme (Custom slider style)
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.primary.withAlpha(76),
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withAlpha(51),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondaryDark,
      selectedIconTheme: IconThemeData(color: AppColors.primary),
      unselectedIconTheme: IconThemeData(color: AppColors.textSecondaryDark),
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surfaceDark,
      titleTextStyle: AppTypography.title.copyWith(color: AppColors.textPrimaryDark),
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.textPrimaryDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.l),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.button,
      ),
    ),

    dividerColor: AppColors.backgroundDark,

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.textPrimaryDark),
      actionTextColor: AppColors.textPrimaryDark,
    ),

    // Use Material 3 design principles
    useMaterial3: true,
  );
}