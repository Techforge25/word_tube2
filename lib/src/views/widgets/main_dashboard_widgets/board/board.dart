import 'dart:math';

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
  final int itemCount = value.gridSizedModel.listData?.length ?? 0;

  // Condition: Agar item count 84 hai to dynamic grid, warna simple grid.
  if (itemCount == 84 || itemCount == 60) {
    // Yeh aapka naya dynamic layout hai jo sirf 84 items ke liye chalega.
    return _buildDynamicGridFor84Grid(
      value: value,
      contentProvider: contentProvider,
      fontSize: fontSize,
      onTap: onTap,
      itemCount: itemCount,
    );
  } else {
    // Yeh purana wala layout hai jo baqi sab lengths ke liye chalega.
    return _buildSimpleGrid(
      value: value,
      contentProvider: contentProvider,
      fontSize: fontSize,
      onTap: onTap,
      itemCount: itemCount,
    );
  }
}

Widget _buildDynamicGridFor84Grid({
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required double fontSize,
  required void Function(String title, int index, GridModel grid) onTap,
  required int itemCount,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (itemCount == 0) return const SizedBox();
      final screenWidth = constraints.maxWidth;
      final screenHeight = constraints.maxHeight;

      // Best column count calculate karne ka logic
      int bestCrossAxisCount = 1;
      for (int i = 1; i <= itemCount; i++) {
        double itemSize = screenWidth / i;
        int rowCount = (itemCount / i).ceil();
        double gridHeight = itemSize * rowCount;
        if (gridHeight <= screenHeight) {
          bestCrossAxisCount = i;
          break;
        }
      }

      return GridView.count(
        crossAxisCount: bestCrossAxisCount,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1, // Square cells ke liye
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(4.0),
        children: List.generate(itemCount, (index) {
          final GridModel grid =
              value.gridSizedModel.listData?[index] ?? GridModel();

          if (value.findTheWord || value.freePlay == false) {
            return gameGridCard(
              context: context,
              value: value,
              contentProvider: contentProvider,
              grid: grid,
              index: index,
              fontSize: fontSize,
              onTap: () => onTap(grid.title ?? '', index, grid),
            );
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
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    isFor84And64Grid: true)
                : Container();
          }
        }),
      );
    },
  );
}

Widget _buildSimpleGrid({
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required double fontSize,
  required void Function(String title, int index, GridModel grid) onTap,
  required int itemCount,
}) {
  int gridSizeX = value.gridSizedModel.gridSizeX ?? 1;
  final listData = value.gridSizedModel.listData;

  if (listData == null || listData.isEmpty) {
    return Container();
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final itemCount = value.gridSizedModel.listData?.length ?? 0;

      if (itemCount == 0) return const SizedBox();

      // Rows & Cols auto adjust
      final crossAxisCount = sqrt(itemCount).ceil();
      final rowCount = (itemCount / crossAxisCount).ceil();

      // Cell ka aspect ratio calculate
      final cellWidth = constraints.maxWidth / crossAxisCount;
      final cellHeight = constraints.maxHeight / rowCount;
      final aspectRatio = cellWidth / cellHeight;
      print("crossAxisCount" + crossAxisCount.toString());
      return GridView.count(
        crossAxisCount: crossAxisCount,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: aspectRatio,
        children: List.generate(itemCount, (index) {
          final GridModel grid =
              value.gridSizedModel.listData?[index] ?? GridModel();

          if (value.findTheWord || value.freePlay == false) {
            return ((grid.hideImage == false) &&
                    (grid.hidetitle == false) &&
                    (grid.title?.isNotEmpty ?? false))
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
                    screenWidth: constraints.maxWidth,
                    screenHeight: constraints.maxHeight,
                  )
                : Container();
          }
        }),
      );
    },
  );
}
