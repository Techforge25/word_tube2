import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:word_toob/app_providers/content_provider.dart';
import 'package:word_toob/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/views/screens/main_dashboard/widegt/button/board.dart';
import 'package:word_toob/views/screens/main_dashboard/widegt/button/plus.dart';
import 'package:word_toob/views/theme/app_color.dart';

class LeftRow extends StatelessWidget {
  final List<Map<String, dynamic>> addMap;
  final double iconSize;
  final double sizeWidth;
  final MenuController menuController2;
  final ContentProvider contentProvider;
  final MainDashboardController value;
  final double fontSize;

  const LeftRow({
    super.key,
    required this.addMap,
    required this.iconSize,
    required this.sizeWidth,
    required this.menuController2,
    required this.contentProvider,
    required this.value,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlusButton(
          addMap: addMap,
          iconSize: iconSize,
          fontSize: fontSize,
        ),
        Gap(sizeWidth),
        MyBoardsButton(
          menuController: menuController2,
          contentProvider: contentProvider,
          value: value,
          fontSize: fontSize,
        ),
        Gap(sizeWidth),
        IconButton(
          onPressed: () => value.setSpeechToText(context),
          splashRadius: 100,
          icon: Container(
            decoration: BoxDecoration(
              color:
                  value.speechToTextCheck ? AppColor.blue : Colors.transparent,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(5),
            child: Icon(
              Icons.mic,
              size: iconSize,
              color: value.speechToTextCheck ? AppColor.white : AppColor.blue,
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     value.setSpeechToText(context);
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color:
        //           value.speechToTextCheck ? AppColor.blue : Colors.transparent,
        //       shape: BoxShape.circle,
        //     ),
        //     padding: const EdgeInsets.all(5),
        //     child: Icon(
        //       Icons.mic,
        //       size: iconSize,
        //       color: value.speechToTextCheck ? AppColor.white : AppColor.blue,
        //     ),
        //   ),
        // ),
        Gap(sizeWidth),
        if (value.lottie || value.speechToTextCheck)
          Lottie.asset(
            'assets/v_player.json',
            animate: value.lottie || value.speechToTextCheck,
          ),
      ],
    );
  }
}
