import 'package:flutter/material.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/utils/common_functions.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/game.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/normal.dart';
// import 'dart:developer' as dev;

Widget mainBoardList({
  required BuildContext context,
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required double fontSize,
  required void Function(String title, int index, GridModel grid) onTap,
}) {
  int gridSizeX = value.gridSizedModel.gridSizeX ?? 1;
  int gridSizeY = value.gridSizedModel.gridSizeY ?? 1;

  return LayoutBuilder(builder: (context, constraints) {
    double size = constraints.maxHeight;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        gridSizeX,
        (x) => Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(gridSizeY, (y) {
              // to finalizing index
              int index = x * gridSizeY + y;
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
