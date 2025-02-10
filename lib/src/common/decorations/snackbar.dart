import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

class AppSnacks {
  static void snackbar({
    required String message,
    String title = '',
  }) {
    Get.snackbar(
      title,
      message,
      dismissDirection: DismissDirection.vertical,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColor.white,
      colorText: AppColor.cardColor,
    );
  }
}
