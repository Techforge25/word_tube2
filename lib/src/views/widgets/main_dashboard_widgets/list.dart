import 'package:flutter/material.dart';

import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/utils/common_functions.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/game.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/normal.dart';

/// Main board list widget that displays grid items in a list format
Widget mainBoardList({
  required BuildContext context,
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required double fontSize,
  required void Function(
    String title,
    int index,
    GridModel grid,
  ) onTap,
}) {
  int gridSizeX = value.gridSizedModel.gridSizeX ?? 1;
  int gridSizeY = value.gridSizedModel.gridSizeY ?? 1;
  final List<GridModel> listData = value.gridSizedModel.listData ?? [];

  final bool isEightyFour = (listData.length == 84) || (listData.length == 60);

  return LayoutBuilder(builder: (context, constraints) {
    double size = constraints.maxHeight;

    // Debug print (optional)
    debugPrint('GridX: $gridSizeX, GridY: $gridSizeY, Size: $size');

    final int rowCount = isEightyFour ? gridSizeY : gridSizeX;
    final int colCount = isEightyFour ? gridSizeX : gridSizeY;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        rowCount,
        (x) => Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(colCount, (y) {
              // to finalizing index
              int index = x * colCount + y;
              if (value.gridSizedModel.listData == null) {
                return Container();
              }

              if (index < value.gridSizedModel.listData!.length) {
                final GridModel grid =
                    value.gridSizedModel.listData?[index] ?? GridModel();
                if (value.findTheWord || value.freePlay == false) {
                  return Flexible(
                    child: gameGridCard(
                      context: context,
                      value: value,
                      contentProvider: contentProvider,
                      grid: grid,
                      index: index,
                      fontSize: fontSize,
                      size: size,
                      onTap: () => onTap(grid.title ?? '', index, grid),
                    ),
                  );
                } else {
                  return CommonFunctions.getCheckforGridShow(
                    isEditPressedYellow: value.editPressedYello,
                    hideImage: grid.hideImage ?? false,
                    hideTitle: grid.hidetitle ?? false,
                  )
                      ? Flexible(
                          child: basicGrid(
                            value: value,
                            contentProvider: contentProvider,
                            grid: grid,
                            index: index,
                            fontSize: fontSize,
                            size: size,
                            screenWidth: constraints.maxWidth,
                            screenHeight: constraints.maxHeight,
                          ),
                        )
                      : Flexible(child: Container());
                }
              } else {
                return Flexible(child: Container());
              }
            }),
          ),
        ),
      ),
    );
  });
}
