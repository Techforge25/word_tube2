import 'package:flutter/material.dart';

/// App color constants used throughout the application
abstract class AppColor {
  const AppColor._();

  // Basic colors
  static const black = Colors.black;
  static const white = Colors.white;
  static const transparent = Colors.transparent;
  static const red = Colors.red;
  static const green = Colors.green;
  static const blue = Colors.blue;
  static const grey = Colors.grey;

  // Border colors
  static const borderColor = Color(0xFF6B4E45);
  static const borderColor2 = Color(0x88DCDCDC);
  static const borderColor3 = Colors.grey;
  static const borderColor4 = Color(0xFFE0E0E0);
  static const borderColor5 = Color(0xFFDEE2E7);
  static const lightBorderColor = Color(0xFFE8ECF4);
  static const darkBorderColor = Color(0xFFCAC4D0);

  // Text colors
  static const textBodyColor = Color(0xFF030319);
  static const fontColor = Colors.blue;
  static const fontColor2 = Color.fromARGB(255, 156, 123, 113);
  static const lightTextColor2 = Color(0xFF2A2B4C);
  static const lightTextColor3 = Color(0xFF273746);
  static const lightTextColor4 = Color(0xFF2C3E50);
  static const lightTextColor5 = Color(0xFF566573);
  static const lightTextColor6 = Color(0xFF808B96);
  static const lightTextColorH = Color(0xFF8391A1);
  static const darkTextColor1 = Color(0xFFE6E0E9);
  static const darkTextColor2 = Color(0xFFCAC4D0);
  static const darkTextColor3 = Color(0xFFF2F3F4);
  static const darkTextColor4 = Color(0xFFEAEDED);
  static const darkTextColor5 = Color(0xFFF2F4F4);
  static const darkTextColor6 = Color(0xFFCAC4D0);
  static const darkTextColorH = Color(0xFFCAC4D0);

  // UI element colors
  static const errorBorderColor = Colors.red;
  static const percentIndicatorColor = Color(0xFF1E7280);
  static const appPrimaryColor = Colors.black54;
  static const pressedColor = Color(0xFFFABFB5);
  static const bottomBarTextColor = Color(0xFF6B4E45);
  static const floatingActionButtonColor = Color(0xFF1C274C);
  static const backgroundColor = Color(0xFFE9DFCF);
  static const buttonColor = Color(0xFFD16A59);
  static const textFieldColor = Color(0xFFF8F3EF);
  static const ratingColor = Color(0xFFFF9017);
  static const dotUnActiveColor = Color(0xFFA7A7A7);
  static const checkMarkColor = Colors.blue;
  static const emailColor = Color(0xFF939393);
  static const liveAuctionColor = Color(0xFF2DE000);
  static const tabBarBackgroundColor = Color(0xFFD8C2AC);
  static const cardColor = Color(0xFF043472);
  static const lightBlue = Color(0xD8468CF1);

  // Shadow and overlay colors
  static Color shadowColor = Colors.grey.shade200;
  static Color shadowColor2 = Colors.grey.shade300;

  // Accent colors
  static Color yellow = Color(0xffFFB038);
  static Color purple = Color(0xff543681);
  static Color greenLight = Color(0xff4AC76D);
  static Color lightgreen = Color(0xFF24FF00);
  static Color barcolor2 = Color(0xFFFFC700);
  static Color smallcard = Color(0xFFD8C2AC);

  // Background colors
  static Color backgroundTab = Color(0xffF5F5F5);
  static Color backgroundCard = Color(0xffF5F6FA);
  static Color bluelinechart = Color(0xFF5A607F);
  static Color messagebarcolor = Color(0xFFD8C2AC);
  static Color splashColor = Color(0xFF07093a);
  static Color splashColor2 = Color(0xFFD2D0D3);

  // Light theme colors
  static const lightSecondaryColor = Color(0xFF073E88);
  static const lightScaffoldBGColor = Color(0xFF1E5FB7);
  static const lightBottomAppbarColor = Color.fromRGBO(42, 43, 76, 0.08);
  static const lightBottomIndicatorColor = Color.fromRGBO(42, 43, 76, 0.2);
  static const lightBottomIconColor = Color(0xFF2A2B4C);
  static const lightHighlightColor = Color(0xFFF4F0FF);
  static const lightDividerColor = Color(0xFFE8ECF4);

  // Dark theme colors
  static const darkSecondaryColor = Color.fromRGBO(43, 41, 48, 1);
  static const darkScaffoldBGColor = Color(0xFF1E1D29);
  static const darkBottomAppbarColor = Color.fromRGBO(43, 41, 48, 1);
  static const darkBottomIconColor = Color(0xFFE6E0E9);
  static const darkBottomIndicatorColor = Color.fromRGBO(230, 224, 233, 0.4);
  static const darkHighlightColor = Color(0xFFF4F0FF);
  static const darkDividerColor = Color(0xFFE6E0E9);
}
