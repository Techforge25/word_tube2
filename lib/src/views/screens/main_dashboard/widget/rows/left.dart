import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/button/board.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/button/plus.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Gap(10),
        if (value.speechToTextCheck)
          Transform.flip(
            flipX: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                10,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  width: 5,
                  height: 35,
                  decoration: BoxDecoration(
                    color:
                        (value.soundLevel / 10 * (index + 1)).clamp(5.0, 50.0) >
                                7
                            ? Colors.green
                            : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
        // if (value.lottie || value.speechToTextCheck)
        //   Lottie.asset(
        //     'assets/v_player.json',
        //     animate: value.lottie || value.speechToTextCheck,
        //   ),
      ],
    );
  }
}
