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
  final TextEditingController _controler;

  const EditWidget({
    super.key,
    required this.sizeWidth,
    required TextEditingController controler,
    required this.value,
    required this.contentProvider,
  }) : _controler = controler;

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  @override
  Widget build(BuildContext context) {
    // double fontSize = context.height * 0.025;
    // double iconSize = context.height * 0.04;
    late double fontSize;
    late double iconSize;
    Orientation orientation = MediaQuery.orientationOf(context);
    if (orientation == Orientation.landscape) {
      fontSize = context.width * 0.015;
      iconSize = context.width * 0.025;
    } else {
      fontSize = context.height * 0.025;
      iconSize = context.height * 0.04;
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
              )),
          Gap(widget.sizeWidth + 60),
          Flexible(
            child: CupertinoSearchTextField(
              padding: const EdgeInsets.all(5),
              prefixIcon: Icon(
                Icons.search,
                size: iconSize + 2,
              ),
              style: TextStyle(fontSize: fontSize + 3),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10)),
              controller: widget._controler,
            ),
          ),
          Gap(widget.sizeWidth + 60),
          TextButton(
              onPressed: () async => widget.value.setDone(),
              child: Text(
                "Done",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize + 2,
                    color: AppColor.appPrimaryColor),
              ))
        ],
      ),
    );
  }
}
