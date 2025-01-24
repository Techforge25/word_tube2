import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

Widget gameGridCard({
  required BuildContext context,
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required GridModel grid,
  required int index,
  void Function()? onTap,
  required double fontSize,
  double? size,
}) {
  final findTheWrongWord = !value.findTheWordWrongList.contains(index);
  return Builder(
    builder: (c) => InkWell(
      onTap: onTap,
      // onTap: () {
      //   if (value.targetFindWord == grid.title) {
      //     value.setFindWordImage(true);
      //     value.setFoundSuccess(true);
      //     _onImageTap(MyAssets.correct);
      //   } else {
      //     widget.value.setFindTheWordWrongList(index);
      //     widget.value.setFindWordImage(true);
      //     _onImageTap(MyAssets.wrong);
      //   }
      // },
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 1,
        ),
        decoration: BoxDecoration(
          color: findTheWrongWord ? AppColor.cardColor : AppColor.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: findTheWrongWord ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.height * 0.02,
              horizontal: context.width * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  findTheWrongWord ? grid.title ?? '?' : "",
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        // Adjust the font size if necessary
                        fontSize: fontSize,
                      ),
                ),
                // Add spacing between text and image
                SizedBox(height: context.height * 0.02),
                findTheWrongWord
                    ? Flexible(
                        child: grid.imagepath != null
                            ? grid.imagepath!.contains("assets")
                                ? Image.asset(
                                    grid.imagepath!,
                                    height: context.height * 0.5,
                                    width: context.height * 0.5,
                                  )
                                : Image.file(
                                    File(grid.imagepath!),
                                    height: context.height * 0.5,
                                    width: context.height * 0.5,
                                  )
                            : SizedBox(),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
