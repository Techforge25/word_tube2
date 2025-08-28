// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

abstract class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme = _buildShrineTheme();
  static ThemeData darkTheme = ThemeData.dark();

  static const String Pacifico = "Pacifico";
  static const String Inter = "Inter-Regular";
  static const double _letterSpacing = 0.5;
}

// ThemeData _darkTheme(){
//   final ThemeData base = ThemeData.dark(useMaterial3: true);
//   return base.copyWith(
//       primaryColor: AppColor.primaryColor,
//       scaffoldBackgroundColor: AppColor.darkScaffoldBGColor,
//       highlightColor: AppColor.darkHighlightColor,
//       colorScheme: base.colorScheme.copyWith(
//           primary: AppColor.primaryColor,
//           secondary: AppColor.darkSecondaryColor
//       ),
//       dividerTheme: const DividerThemeData(
//           color: AppColor.darkDividerColor
//       ),
//       listTileTheme: const ListTileThemeData(
//           shape: RoundedRectangleBorder(side: BorderSide.none),
//           textColor: AppColor.black),
//       cardTheme: CardTheme(
//         elevation: 0.0,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             side: const BorderSide(color: AppColor.borderColor)
//         ),
//       ),
//       datePickerTheme: const DatePickerThemeData(
//           backgroundColor: AppColor.darkScaffoldBGColor,
//           surfaceTintColor: AppColor.darkScaffoldBGColor,
//           headerHeadlineStyle: TextStyle(
//               fontFamily: AppTheme.latoFont,
//               fontWeight: FontWeight.w500,
//               color: AppColor.darkTextColor1,
//               fontSize: 22,
//               letterSpacing: AppTheme._letterSpacing,
//               overflow: TextOverflow.ellipsis
//           ),
//           headerHelpStyle: TextStyle(
//               fontFamily: AppTheme.latoFont,
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//               color: AppColor.darkTextColor1,
//               letterSpacing: AppTheme._letterSpacing,
//               overflow: TextOverflow.ellipsis
//           ),
//           weekdayStyle: TextStyle(
//               fontFamily: AppTheme.latoFont,
//               fontWeight: FontWeight.w500,
//               fontSize: 14.0,
//               color: AppColor.darkTextColor2,
//               letterSpacing: AppTheme._letterSpacing,
//               overflow: TextOverflow.ellipsis
//           ),
//           dayStyle: TextStyle(
//               fontFamily: AppTheme.latoFont,
//               fontWeight: FontWeight.w400,
//               fontSize: 12.0,
//               color: AppColor.darkTextColor2,
//               letterSpacing: AppTheme._letterSpacing,
//               overflow: TextOverflow.ellipsis
//           ),
//           yearStyle: TextStyle(
//               fontFamily: AppTheme.latoFont,
//               fontWeight: FontWeight.w400,
//               fontSize: 14.0,
//               color: AppColor.darkTextColor2,
//               letterSpacing: AppTheme._letterSpacing,
//               overflow: TextOverflow.ellipsis
//           )
//       ),
//       ///InputDecorationTheme
//       inputDecorationTheme: InputDecorationTheme(
//           iconColor: AppColor.white,
//           filled: true,
//           fillColor: AppColor.transparent,
//           hintStyle: const TextStyle(
//               color: AppColor.darkTextColorH
//           ),
//           errorStyle: const TextStyle(
//               fontFamily: AppTheme.latoFont,
//               fontWeight: FontWeight.w400,
//               fontSize: 14.0,
//               color: AppColor.errorBorderColor,
//               letterSpacing: AppTheme._letterSpacing,
//               overflow: TextOverflow.ellipsis
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
//             borderSide: const BorderSide(color: AppColor.darkBorderColor),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
//             borderSide: const BorderSide(color: AppColor.darkBorderColor),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
//             borderSide: const BorderSide(color: AppColor.primaryColor),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
//             borderSide: const BorderSide(color: AppColor.errorBorderColor),
//           ),
//           disabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
//             borderSide: const BorderSide(color: AppColor.darkBorderColor),
//           )
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColor.appPrimaryColor,
//           textStyle: const TextStyle(
//               fontFamily: 'Lato',
//               fontWeight: FontWeight.w600,
//               color: AppColor.white,
//               fontSize: 20.0),
//           // primary: Colors.grey[300],
//           // minimumSize: Size(88, 36),
//           //padding: EdgeInsets.symmetric(vertical: 16),
//           fixedSize: const Size(0, 52),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(6.0),
//             ),
//           ),
//         ),
//       ),
//       appBarTheme: const AppBarTheme(
//           elevation: 0.0,
//           centerTitle: true,
//           toolbarHeight: kToolbarHeight,
//           backgroundColor: AppColor.primaryColor,
//           titleTextStyle: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.w700,
//               color: AppColor.white)
//       ),
//       iconTheme: const IconThemeData(color: AppColor.darkTextColor3),
//       bottomAppBarTheme: const BottomAppBarTheme(
//           color: AppColor.darkBottomAppbarColor,
//           surfaceTintColor: AppColor.darkBottomIconColor,
//           shadowColor: AppColor.darkBottomIndicatorColor
//       ),
//       ///restore textTheme
//       hintColor: AppColor.darkTextColorH,
//       textTheme: const TextTheme(
//         titleLarge: TextStyle(
//             fontFamily: AppTheme.latoFont,
//             fontWeight: FontWeight.w700,
//             fontSize: 30.0,
//             color: AppColor.darkTextColor1,
//             letterSpacing: AppTheme._letterSpacing,
//             overflow: TextOverflow.ellipsis
//         ),
//         titleMedium: TextStyle(
//             fontFamily: AppTheme.Pacifico,
//             fontWeight: FontWeight.w400,
//             fontSize: 28.0,
//             color: AppColor.darkTextColor2,
//             letterSpacing: AppTheme._letterSpacing,
//             overflow: TextOverflow.ellipsis
//         ),
//         titleSmall: TextStyle(
//             fontFamily: AppTheme.Pacifico,
//             fontWeight: FontWeight.w400,
//             fontSize: 18.0,
//             color: AppColor.darkTextColor3,
//             letterSpacing: AppTheme._letterSpacing,
//             overflow: TextOverflow.ellipsis
//         ),
//         bodyLarge: TextStyle(
//             fontFamily: AppTheme.Pacifico,
//             fontWeight: FontWeight.w900,
//             fontSize: 28.0,
//             color: AppColor.darkTextColor4,
//             letterSpacing: AppTheme._letterSpacing,
//             overflow: TextOverflow.ellipsis
//         ),
//         bodyMedium: TextStyle(
//             fontFamily: AppTheme.Pacifico,
//             fontWeight: FontWeight.w600,
//             fontSize: 26.0,
//             color: AppColor.darkTextColor5,
//             letterSpacing: AppTheme._letterSpacing,
//             overflow: TextOverflow.ellipsis
//         ),
//         bodySmall: TextStyle(
//             fontFamily: AppTheme.Pacifico,
//             fontWeight: FontWeight.w400,
//             fontSize: 24.0,
//             color: AppColor.darkTextColor6,
//             letterSpacing: AppTheme._letterSpacing,
//             overflow: TextOverflow.ellipsis
//         ),
//       )//.apply(bodyColor: AppColor.white),
//   );
// }

///light
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
      primaryColor: AppColor.lightScaffoldBGColor,
      scaffoldBackgroundColor: AppColor.lightScaffoldBGColor,
      highlightColor: AppColor.lightHighlightColor,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColor.appPrimaryColor,
        secondary: AppColor.lightSecondaryColor,
      ),
      dividerTheme: const DividerThemeData(color: AppColor.lightDividerColor),
      listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(side: BorderSide.none),
          textColor: AppColor.black),
      cardTheme: CardThemeData(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: AppColor.borderColor)),
      ),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: AppColor.lightScaffoldBGColor,
        surfaceTintColor: AppColor.lightScaffoldBGColor,

        ///complete date view
        headerHeadlineStyle: TextStyle(
            // fontFamily: AppTheme.latoFont,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: AppColor.fontColor,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),

        ///select date
        headerHelpStyle: TextStyle(
            // fontFamily: AppTheme.latoFont,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: AppColor.fontColor,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
        weekdayStyle: TextStyle(
            // fontFamily: AppTheme.latoFont,
            fontWeight: FontWeight.w500,
            fontSize: 10.0,
            color: AppColor.lightTextColor2,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
        dayStyle: TextStyle(
            fontFamily: AppTheme.Pacifico,
            fontWeight: FontWeight.w400,
            fontSize: 06.0,
            color: AppColor.lightTextColor2,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
        yearStyle: TextStyle(
            fontFamily: AppTheme.Pacifico,
            fontWeight: FontWeight.w400,
            fontSize: 10.0,
            color: AppColor.lightTextColor2,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
      ),

      ///InputDecorationTheme
      inputDecorationTheme: InputDecorationTheme(
          iconColor: AppColor.black,
          filled: true,
          fillColor: AppColor.transparent,
          errorStyle: const TextStyle(
              fontFamily: AppTheme.Pacifico,
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              color: AppColor.errorBorderColor,
              letterSpacing: AppTheme._letterSpacing,
              overflow: TextOverflow.ellipsis),
          //contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
            borderSide: const BorderSide(color: AppColor.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
            borderSide: const BorderSide(color: AppColor.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
            borderSide: const BorderSide(color: AppColor.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
            borderSide: const BorderSide(color: AppColor.errorBorderColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppUtility.defaultBorderRadius),
            borderSide: const BorderSide(color: AppColor.lightBorderColor),
          )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.appPrimaryColor,
          textStyle: const TextStyle(
              // fontFamily: AppTheme.latoFont,
              fontWeight: FontWeight.w900,
              color: AppColor.white,
              fontSize: 20.0),
          // primary: Colors.grey[300],
          // minimumSize: Size(88, 36),
          //padding: EdgeInsets.symmetric(vertical: 16),
          fixedSize: const Size(0, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
          elevation: 0.0,
          centerTitle: true,
          toolbarHeight: kToolbarHeight,
          backgroundColor: AppColor.appPrimaryColor,
          titleTextStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: AppColor.white)),
      iconTheme: const IconThemeData(color: AppColor.fontColor),
      bottomAppBarTheme: const BottomAppBarThemeData(
          color: AppColor.lightBottomAppbarColor,
          surfaceTintColor: AppColor.lightBottomIconColor,
          shadowColor: AppColor.lightBottomIndicatorColor),

      ///restore textTheme
      hintColor: AppColor.lightTextColorH, // AppColor.lightTextColorH,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontFamily: AppTheme.Inter,
            fontWeight: FontWeight.w600,
            fontSize: 38.0,
            color: AppColor.fontColor,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
        titleMedium: TextStyle(
            fontFamily: AppTheme.Inter,
            fontWeight: FontWeight.w400,
            fontSize: 32.0,
            color: AppColor.fontColor,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
        titleSmall: TextStyle(
            fontFamily: AppTheme.Inter,
            fontWeight: FontWeight.w400,
            fontSize: 22.0,
            color: AppColor.fontColor,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
        bodyLarge: TextStyle(
            fontFamily: AppTheme.Inter,
            fontWeight: FontWeight.w900,
            fontSize: 19.0,
            color: AppColor.fontColor,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
        bodyMedium: TextStyle(
          fontFamily: AppTheme.Inter,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          color: AppColor.fontColor,
          letterSpacing: AppTheme._letterSpacing,
          overflow: TextOverflow.ellipsis,
        ),
        bodySmall: TextStyle(
            fontFamily: AppTheme.Inter,
            fontWeight: FontWeight.w400,
            fontSize: 13.0,
            color: AppColor.fontColor,
            letterSpacing: AppTheme._letterSpacing,
            overflow: TextOverflow.ellipsis),
      ) //.apply(displayColor: AppColor.black),
      );
}
