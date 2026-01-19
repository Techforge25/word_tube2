import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/button/setting.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/center_tile.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/rows/left.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/rows/right.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

/// Navigation bar widget for the main dashboard
class NormalNavBar extends StatelessWidget {
  final MainDashboardController value;
  final ContentProvider contentProvider;
  final MenuController menuController;
  final List<Map<String, dynamic>> addMap;
  final double sizeWidth;

  const NormalNavBar({
    super.key,
    required this.addMap,
    required this.sizeWidth,
    required this.value,
    required this.contentProvider,
    required this.menuController,
  });

  @override
  Widget build(BuildContext context) {
    final gameMap = _buildGameMap();
    final fontSize = _calculateFontSize(context);
    final iconSize = _calculateIconSize(context);
    final gap = 15.0;

    return Container(
      height: context.height * 0.12,
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LeftRow(
            addMap: addMap,
            menuController2: MenuController(),
            sizeWidth: sizeWidth,
            contentProvider: contentProvider,
            value: value,
            iconSize: iconSize + 2,
            fontSize: fontSize + 2,
          ),
          CenterTitle(value: value, fontSize: fontSize + 6),
          _buildRightSection(fontSize, sizeWidth, gap),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _buildGameMap() {
    return [
      {
        "name": "Free Play",
        "onTap": () {
          menuController.close();
          value.setFreePlayOn(true);
        }
      },
      {
        "name": "Find The Word",
        "onTap": () {
          menuController.close();
          value.setFindTheWord(true);
          value.setRandomIndex();
        }
      }
    ];
  }

  double _calculateFontSize(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    if (orientation == Orientation.landscape) {
      return context.width * 0.015;
    } else {
      fontSize = context.height * 0.025;
      iconSize = context.height * 0.04;
    }

    double gap = 15;

    return Container(
      height: context.height * 0.12,
      color: AppColor.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LeftRow(
            addMap: addMap,
            menuController2: menuController2,
            sizeWidth: sizeWidth,
            contentProvider: contentProvider,
            value: value,
            iconSize: iconSize + 2,
            fontSize: fontSize + 2,
          ),
          Expanded(child: CenterTitle(value: value, fontSize: fontSize + 6)),
          SizedBox(
            width: 4,
          ),
          !value.findTheWord
              ? RightRow(
                  menuController: menuController,
                  gameMap: gameMap,
                  fontSize: fontSize + 2,
                  sizeWidth: sizeWidth,
                  value: value,
                  gap: gap,
                )
              : FindTheWordRow(
                  fontSize: fontSize + 2,
                  sizeWidth: sizeWidth,
                  mainDashboardController: value,
                  menuController: menuController,
                )
        ],
      ),
    );
  }
}

/// Row widget for the "Find The Word" game mode
class FindTheWordRow extends StatelessWidget {
  final MainDashboardController mainDashboardController;
  final double fontSize;
  final double sizeWidth;
  final MenuController menuController;

  const FindTheWordRow({
    super.key,
    required this.fontSize,
    required this.sizeWidth,
    required this.mainDashboardController,
    required this.menuController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            if (!mainDashboardController.isRepeateTap) {
              mainDashboardController.setIsRepeate(true);
              mainDashboardController.setCurrentIndex();
              mainDashboardController.clearFindTheWrongList();
              mainDashboardController.setIsRepeate(false);
            }
          },
        ),
        SizedBox(width: sizeWidth),
        _buildTextButton(
          context,
          "Skip",
          () {
            mainDashboardController.setRandomIndex();
            mainDashboardController.clearFindTheWrongList();
          },
        ),
        SizedBox(width: sizeWidth),
        SettingButton(
          fontSize: fontSize,
          gap: 5,
          value: mainDashboardController,
          gameMenuController: menuController,
        ),
        SizedBox(width: sizeWidth),
        _buildDoneButton(context),
      ],
    );
  }

  Widget _buildTextButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mainDashboardController.setFindTheWord(false);
        mainDashboardController.clearFindTheWrongList();
        mainDashboardController.setFindWordImage(false);
      },
      child: Text(
        "Done",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor.appPrimaryColor,
              fontSize: fontSize,
            ),
      ),
    );
  }
}
