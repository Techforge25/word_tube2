// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

abstract class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme = _buildShrineTheme();
  static ThemeData darkTheme = _buildDarkTheme();

  static const String Pacifico = "Pacifico";
  static const String Inter = "Inter-Regular";
  static const double _letterSpacing = 0.5;
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    primaryColor: AppColor.appPrimaryColor,
    scaffoldBackgroundColor: AppColor.lightScaffoldBGColor,
    highlightColor: AppColor.lightHighlightColor,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColor.appPrimaryColor,
      secondary: AppColor.lightSecondaryColor,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColor.lightDividerColor,
    ),
    listTileTheme: const ListTileThemeData(
      shape: RoundedRectangleBorder(side: BorderSide.none),
      textColor: AppColor.black,
    ),
    cardTheme: CardThemeData(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColor.borderColor),
      ),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: AppColor.lightScaffoldBGColor,
      surfaceTintColor: AppColor.lightScaffoldBGColor,
      headerHeadlineStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        color: AppColor.textBodyColor,
        fontSize: 22,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      headerHelpStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      weekdayStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        color: AppColor.lightTextColor2,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      dayStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        color: AppColor.lightTextColor2,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      yearStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        color: AppColor.lightTextColor2,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: AppColor.black,
      filled: true,
      fillColor: AppColor.textFieldColor,
      hintStyle: const TextStyle(
        color: AppColor.lightTextColorH,
      ),
      errorStyle: const TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        color: AppColor.errorBorderColor,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.lightBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.lightBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.appPrimaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.errorBorderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.lightBorderColor),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.lightBottomAppbarColor,
      selectedItemColor: AppColor.lightBottomIconColor,
      unselectedItemColor: AppColor.lightBottomIconColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.lightScaffoldBGColor,
      foregroundColor: AppColor.textBodyColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      displayMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 28,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      displaySmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      titleLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      titleMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      titleSmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      bodySmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      labelLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      labelMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
      labelSmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 10,
        color: AppColor.textBodyColor,
        letterSpacing: AppTheme._letterSpacing,
      ),
    ),
  );
}

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    primaryColor: AppColor.appPrimaryColor,
    scaffoldBackgroundColor: AppColor.darkScaffoldBGColor,
    highlightColor: AppColor.darkHighlightColor,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColor.appPrimaryColor,
      secondary: AppColor.darkSecondaryColor,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColor.darkDividerColor,
    ),
    listTileTheme: const ListTileThemeData(
      shape: RoundedRectangleBorder(side: BorderSide.none),
      textColor: AppColor.white,
    ),
    cardTheme: CardThemeData(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColor.borderColor),
      ),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: AppColor.darkScaffoldBGColor,
      surfaceTintColor: AppColor.darkScaffoldBGColor,
      headerHeadlineStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        color: AppColor.darkTextColor1,
        fontSize: 22,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      headerHelpStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      weekdayStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        color: AppColor.darkTextColor2,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      dayStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        color: AppColor.darkTextColor2,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      yearStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        color: AppColor.darkTextColor2,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: AppColor.white,
      filled: true,
      fillColor: AppColor.transparent,
      hintStyle: const TextStyle(
        color: AppColor.darkTextColorH,
      ),
      errorStyle: const TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        color: AppColor.errorBorderColor,
        letterSpacing: AppTheme._letterSpacing,
        overflow: TextOverflow.ellipsis,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.darkBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.appPrimaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.errorBorderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColor.darkBorderColor),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.darkBottomAppbarColor,
      selectedItemColor: AppColor.darkBottomIconColor,
      unselectedItemColor: AppColor.darkBottomIconColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.darkScaffoldBGColor,
      foregroundColor: AppColor.darkTextColor1,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      displayMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 28,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      displaySmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      titleLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      titleMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      titleSmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      bodySmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      labelLarge: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      labelMedium: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
      labelSmall: TextStyle(
        fontFamily: AppTheme.Inter,
        fontWeight: FontWeight.w500,
        fontSize: 10,
        color: AppColor.darkTextColor1,
        letterSpacing: AppTheme._letterSpacing,
      ),
    ),
  );
}
