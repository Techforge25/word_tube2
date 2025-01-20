import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:word_toob/app_providers/content_provider.dart';
import 'package:word_toob/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/common/utils/app_utility.dart';
import 'package:word_toob/views/theme/app_color.dart';

class EditWidget extends StatefulWidget {
  final MainDashboardController value;
  final ContentProvider contentProvider;
  const EditWidget({
    super.key,
    required this.sizeWidth,
    required TextEditingController controler,
    required this.value,
    required this.contentProvider,
  }) : _controler = controler;

  final double sizeWidth;
  final TextEditingController _controler;

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  @override
  Widget build(BuildContext context) {
    double fontSize = context.height * 0.025;
    double iconSize = context.height * 0.04;
    return Container(
      color: AppColor.yellow,
      padding: const EdgeInsets.symmetric(
          horizontal: AppUtility.horizontalPadding * 0.5,
          vertical: AppUtility.verticalPadding * 0.3),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                await widget.value.setHideButton(widget.contentProvider);
              },
              child: Text(
                "Hide All",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: AppColor.appPrimaryColor),
              ),
            ),
            Gap(widget.sizeWidth + 20),
            GestureDetector(
              onTap: () async {
                await widget.value.showAllButton(widget.contentProvider);
              },
              child: Text(
                "Show All",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: AppColor.appPrimaryColor),
              ),
            ),
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
            GestureDetector(
              onTap: () async {
                widget.value.setDone();
              },
              child: Text(
                "Done",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: AppColor.appPrimaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
