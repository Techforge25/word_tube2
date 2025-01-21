import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/button/help.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/button/setting.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'package:word_toob/src/views/widgets/custom_menu_widget.dart';

class RightRow extends StatelessWidget {
  final MenuController menuController;
  final List<Map<String, dynamic>> gameMap;
  final double fontSize;
  final double sizeWidth;
  final MainDashboardController value;
  final double gap;

  const RightRow({
    super.key,
    required this.menuController,
    required this.gameMap,
    required this.fontSize,
    required this.sizeWidth,
    required this.value,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomMenuAnchor(
          menuController: menuController,
          menuItems: List.generate(2, (index) {
            return ListTile(
              onTap: gameMap[index]["onTap"],
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              title: Text(
                gameMap[index]["name"],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: fontSize + 4,
                      color: AppColor.appPrimaryColor.withOpacity(0.5),
                    ),
              ),
            );
          }),
          titleWidget: Text(
            "Games",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Gap(sizeWidth),
        GestureDetector(
          onTap: () {
            value.setEdit(true);
          },
          child: Text(
            "Edit",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
          ),
        ),
        Gap(sizeWidth),
        SettingButton(
          fontSize: fontSize,
          gap: gap,
          value: value,
          gameMenuController: menuController,
        ),
        Gap(sizeWidth),
        HelpButton(fontSize: fontSize),
      ],
    );
  }
}
