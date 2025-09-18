import 'package:flutter/material.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/utils/common_functions.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/game.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/normal.dart';

Widget gridBoard({
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required double fontSize,
  required void Function(String title, int index, GridModel grid) onTap,
}) {
  return GridView.builder(
    // shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: value.gridSizedModel.gridSizeY ?? 4,
      childAspectRatio: 1,
    ),

    itemCount: value.gridSizedModel.listData?.length,
    itemBuilder: (context, index) {
      final GridModel grid =
          value.gridSizedModel.listData?[index] ?? GridModel();

      if (value.findTheWord || value.freePlay == false) {
        return ((grid.hideImage == false) && (grid.hidetitle == false))
            ? gameGridCard(
                context: context,
                value: value,
                contentProvider: contentProvider,
                grid: grid,
                index: index,
                fontSize: fontSize,
                onTap: () => onTap(
                  grid.title ?? '',
                  index,
                  grid,
                ),
              )
            : Container();
      } else {
        return CommonFunctions.getCheckforGridShow(
          isEditPressedYellow: value.editPressedYello,
          hideImage: grid.hideImage ?? false,
          hideTitle: grid.hidetitle ?? false,
        )
            ? basicGrid(
                value: value,
                contentProvider: contentProvider,
                grid: grid,
                index: index,
                fontSize: fontSize,
              )
            : Container();
      }
    },
  );
}
