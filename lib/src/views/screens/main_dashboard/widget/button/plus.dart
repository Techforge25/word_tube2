import 'package:flutter/material.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'package:word_toob/src/views/widgets/custom_menu_widget.dart';

class PlusButton extends StatelessWidget {
  final List<Map<String, dynamic>> addMap;
  final double iconSize;
  final double fontSize;

  const PlusButton({
    super.key,
    required this.addMap,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
        menuItems: List.generate(
          addMap.length,
          (index) => ListTile(
            onTap: addMap[index]["onTap"],
            tileColor: index == 0 ? AppColor.shadowColor : AppColor.white,
            title: Text(
              addMap[index]["name"],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColor.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
            ),
          ),
        ),
        titleWidget: Icon(
          Icons.add,
          size: iconSize,
        ));
  }
}
