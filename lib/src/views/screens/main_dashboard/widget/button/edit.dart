import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

class EditWidget extends StatefulWidget {
  final MainDashboardController value;
  final ContentProvider contentProvider;
  final double sizeWidth;
  final TextEditingController controler;

  const EditWidget({
    super.key,
    required this.sizeWidth,
    required this.value,
    required this.contentProvider,
    required this.controler,
  });

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  @override
  Widget build(BuildContext context) {
    // double fontSize = context.height * 0.025;
    // double iconSize = context.height * 0.04;
    late double fontSize;

    Orientation orientation = MediaQuery.orientationOf(context);
    if (orientation == Orientation.landscape) {
      fontSize = context.width * 0.015;
    } else {
      fontSize = context.height * 0.025;
    }

    return Container(
      height: context.height * 0.12,
      color: AppColor.yellow,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () async =>
                await widget.value.setHideButton(widget.contentProvider),
            child: Text(
              "Hide All",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize + 2,
                  color: AppColor.appPrimaryColor),
            ),
          ),
          Gap(widget.sizeWidth + 20),
          TextButton(
            onPressed: () async =>
                await widget.value.showAllButton(widget.contentProvider),
            child: Text(
              "Show All",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize + 2,
                  color: AppColor.appPrimaryColor),
            ),
          ),
          Gap(widget.sizeWidth + 60),
          Flexible(
            child: CupertinoTextField(
              style: TextStyle(fontSize: fontSize + 4),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(7.5),
              ),
              cursorColor: AppColor.yellow,
              maxLines: 1,
              padding: EdgeInsets.all(context.height * 0.02),
              controller: widget.controler,
            ),
          ),
          Gap(widget.sizeWidth + 60),
          TextButton(
            onPressed: () async => widget.value.setDone(widget.contentProvider),
            child: Text(
              "Done",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize + 2,
                    color: AppColor.appPrimaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
