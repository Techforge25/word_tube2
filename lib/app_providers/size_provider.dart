import 'package:flutter/material.dart';

class SizeProvider {
  SizeProvider._();
  // static final SizeProvider heightProvider = SizeProvider._();

// To get the genaric font size for all the app text.
  double fontSize(context) {
    late double f;
    Orientation orientation = MediaQuery.orientationOf(context);
    if (orientation == Orientation.landscape) {
      f = context.width * 0.082;
    } else {
      f = context.height * 0.082;
    }

    return f;
  }
}
