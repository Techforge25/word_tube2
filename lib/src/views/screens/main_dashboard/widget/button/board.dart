import 'package:flutter/material.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'package:word_toob/src/views/widgets/custom_menu_widget.dart';
import 'dart:developer' as dev;

class MyBoardsButton extends StatelessWidget {
  final MenuController menuController;
  final ContentProvider contentProvider;
  final MainDashboardController value;
  final double fontSize;

  const MyBoardsButton({
    super.key,
    required this.menuController,
    required this.contentProvider,
    required this.value,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
      menuController: menuController,
      menuItems:
          List.generate(contentProvider.allGridSizedModel.length, (index) {
        return ListTile(
          onTap: () {
// setting playing mode off
            value.setFindTheWord(false);
            value.setRandomListIndex(0);

            value.setGridSize(
              contentProvider.allGridSizedModel[index].gridSizeX ?? 1,
              contentProvider.allGridSizedModel[index].gridSizeY ?? 2,
            );
            value.setGridSizedModel(
              contentProvider.allGridSizedModel[index],
              index,
            );

            dev.log("$index", name: "Index");

            int count =
                contentProvider.allGridSizedModel[index].duplicateCount + 1;

            GridSizeModel gridSizeModel = GridSizeModel(
              currentSelected: true,
              duplicateCount: count,
              listData: contentProvider.allGridSizedModel[index].listData,
              gridSizeY: contentProvider.allGridSizedModel[index].gridSizeY,
              gridSizeX: contentProvider.allGridSizedModel[index].gridSizeX,
              title:
                  "${contentProvider.allGridSizedModel[index].title} copy $count ",
            );
            count = 0;

            value.makeDuplicateGridSizedModel(gridSizeModel);
            menuController.close();
          },
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          title: Text(
            contentProvider.allGridSizedModel[index].title ?? "",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
        );
      }),
      titleWidget: Text(
        "My Boards",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
