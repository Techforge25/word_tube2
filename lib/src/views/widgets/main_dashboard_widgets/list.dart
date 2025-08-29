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
  required void Function(String title, int index, GridModel grid) onTap,
}) {
  final gridSizeX = value.gridSizedModel.gridSizeX ?? 1;
  final gridSizeY = value.gridSizedModel.gridSizeY ?? 1;

  return LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxHeight;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          gridSizeX,
          (x) => Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                gridSizeY,
                (y) => _buildGridItem(
                  x: x,
                  y: y,
                  gridSizeY: gridSizeY,
                  value: value,
                  contentProvider: contentProvider,
                  fontSize: fontSize,
                  size: size,
                  onTap: onTap,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Build individual grid item based on game state and visibility
Widget _buildGridItem({
  required int x,
  required int y,
  required int gridSizeY,
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required double fontSize,
  required double size,
  required void Function(String title, int index, GridModel grid) onTap,
}) {
  final index = x * gridSizeY + y;

  if (value.gridSizedModel.listData == null ||
      index >= value.gridSizedModel.listData!.length) {
    return const Flexible(
        child: SizedBox.shrink()); // Use SizedBox.shrink() for empty space
  }

  final grid = value.gridSizedModel.listData?[index] ?? GridModel();

  if (value.findTheWord || value.freePlay == false) {
    return _buildGameGridCard(
      context: null, // Context not needed for this widget
      value: value,
      contentProvider: contentProvider,
      grid: grid,
      index: index,
      fontSize: fontSize,
      size: size,
      onTap: () => onTap(grid.title ?? '', index, grid),
    );
  } else {
    return _buildBasicGridIfVisible(
      value: value,
      contentProvider: contentProvider,
      grid: grid,
      index: index,
      fontSize: fontSize,
      size: size,
    );
  }
}

/// Build game grid card for interactive gameplay
Widget _buildGameGridCard({
  required BuildContext? context,
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required GridModel grid,
  required int index,
  required double fontSize,
  required double size,
  required VoidCallback onTap,
}) {
  return Flexible(
    child: gameGridCard(
      context: context!,
      value: value,
      contentProvider: contentProvider,
      grid: grid,
      index: index,
      fontSize: fontSize,
      size: size,
      onTap: onTap,
    ),
  );
}

/// Build basic grid if it should be visible based on settings
Widget _buildBasicGridIfVisible({
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required GridModel grid,
  required int index,
  required double fontSize,
  required double size,
}) {
  final shouldShow = CommonFunctions.getCheckforGridShow(
    isEditPressedYellow: value.editPressedYello,
    hideImage: grid.hideImage ?? false,
    hideTitle: grid.hidetitle ?? false,
  );

  if (!shouldShow) {
    return const Flexible(
        child: SizedBox.shrink()); // Use SizedBox.shrink() for empty space
  }

  return Flexible(
    child: basicGrid(
      value: value,
      contentProvider: contentProvider,
      grid: grid,
      index: index,
      fontSize: fontSize,
      size: size,
    ),
  );
}
