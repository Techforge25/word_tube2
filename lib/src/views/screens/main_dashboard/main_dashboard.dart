import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/app_strings.dart';
import 'package:word_toob/src/common/app_constants/assets.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/main_dashboard_grid.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/nav_bar.dart';
import 'package:word_toob/src/common/app_constants/general.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'package:word_toob/src/views/screens/main_dashboard/widget/button/edit.dart';

class SharedBoardPreviewScreen extends StatelessWidget {
  final GridSizeModel board;

  const SharedBoardPreviewScreen({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Board Preview"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Board Title: ${board.title}"),
            Text("Grid Size: ${board.gridSizeX}x${board.gridSizeY}"),
            ElevatedButton(
              onPressed: () async {
                // Logic to add the board
                final contentProvider = sl<ContentProvider>();
                final mainDashboardController = sl<MainDashboardController>();

                // Save the board
                await contentProvider.saveGridSizedModel(gridSizedModel: board);

                // Refresh the list to get the newly saved board with its ID
                await contentProvider.getAllGridSizeModel();

                // Find the newly saved board (it should have the same title)
                GridSizeModel? savedBoard;
                int? savedBoardIndex;

                for (int i = 0;
                    i < contentProvider.allGridSizedModel.length;
                    i++) {
                  if (contentProvider.allGridSizedModel[i].title ==
                          board.title &&
                      contentProvider.allGridSizedModel[i].id != null) {
                    savedBoard = contentProvider.allGridSizedModel[i];
                    savedBoardIndex = i;
                    break;
                  }
                }

                // If board was found, set it as current and navigate to main dashboard
                if (savedBoard != null && savedBoardIndex != null) {
                  // Set this board as selected
                  await contentProvider.updateGridSizeModelData(
                    id: savedBoard.id!,
                    currentSelected: true,
                  );

                  // Unselect all other boards
                  for (var otherBoard in contentProvider.allGridSizedModel) {
                    if (otherBoard.id != savedBoard.id &&
                        otherBoard.currentSelected == true) {
                      await contentProvider.updateGridSizeModelData(
                        id: otherBoard.id!,
                        currentSelected: false,
                      );
                    }
                  }

                  // Refresh again to get updated state
                  await contentProvider.getAllGridSizeModel();

                  // Set the board in controller
                  await mainDashboardController.setGridSizedModel(
                      savedBoard, savedBoardIndex);

                  // Navigate to main dashboard - it will automatically show the new board
                  Navigator.of(context).pushReplacementNamed('/');
                } else {
                  // Fallback: just navigate if board not found
                  Navigator.of(context).pushReplacementNamed('/');
                }
              },
              child: Text("Add to My Boards"),
            ),
          ],
        ),
      ),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final _contentProvider = sl<ContentProvider>();
  final _mainDashBoard = sl<MainDashboardController>();

  void saveData() {
    _contentProvider.saveAllGridSizedModel(
      gridSizedModelList: gridModelList,
      contenProvider: _contentProvider,
    );
  }

  @override
  void initState() {
    super.initState();
    _mainDashBoard.setFreePlayOn(true);
    Future.microtask(() => saveData());
    Future.microtask(() => _mainDashBoard.initSpeechToText());

    Future.microtask(() =>
        _mainDashBoard.getCurrentSelectedGridSizedModel(_contentProvider));
    _mainDashBoard.initTextToSpeech();
    _mainDashBoard.setIsMobile();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> customDialogList = [
      {
        "name": "Emotions",
        "gridSizeX": 2,
        "gridSizeY": 4,
      },
      {
        "name": "First 25 Words",
        "gridSizeX": 5,
        "gridSizeY": 5,
      },
      {
        "name": "Numbers",
        "gridSizeX": 5,
        "gridSizeY": 5,
      },
      {
        "name": "2 words",
        "gridSizeX": 1,
        "gridSizeY": 2,
      },
      {
        "name": "4 words",
        "gridSizeX": 2,
        "gridSizeY": 2,
      },
      {
        "name": "6 words",
        "gridSizeX": 2,
        "gridSizeY": 3,
      },
      {
        "name": "12 words",
        "gridSizeX": 3,
        "gridSizeY": 4,
      },
      {
        "name": "15 words",
        "gridSizeX": 3,
        "gridSizeY": 5,
      },
      {
        "name": "25 words",
        "gridSizeX": 5,
        "gridSizeY": 5,
      },
      {
        "name": "60 words",
        "gridSizeX": 5,
        "gridSizeY": 12,
      },
      {
        "name": "84 words",
        "gridSizeX": 6,
        "gridSizeY": 14,
      },
    ];

    List<GridSizeModel> gridSizeModelInitialized = customDialogList.map((item) {
      return GridSizeModel(
        gridSizeX: item['gridSizeX'],
        gridSizeY: item['gridSizeY'],
        currentSelected: false,
        title: item['name'],
        hideModel: false,
        listData: List.generate(
          item['gridSizeX'] * item['gridSizeY'],
          (index) => GridModel(), // Generate your GridModel objects as needed
        ),
      );
    }).toList();

    List<Map<String, dynamic>> addMap = [
      {
        "name": AppString.newBoard,
        "onTap": () {
          _contentProvider.getAllGridSizeModel();
          AppUtility.showCustomDialog(
            context: context,
            title: AppString.newBoard,
            list: gridSizeModelInitialized.reversed.toList(),
            contentProvider: _contentProvider,
          );
        }
      },
      {
        "name": "Duplicate Board",
        "onTap": () async {
          // _contentProvider.saveGridSizedModel(
          //   gridSizedModel: _mainDashBoard.duplicateGridSizedModel,
          // );
          // _mainDashBoard.setEdit(true);

          await _mainDashBoard.duplicateCurrentBoard(_contentProvider, context);
        }
      }
    ];

    double sizeWidth = context.width * 0.02;

    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: Consumer2<MainDashboardController, ContentProvider>(
            builder: (context, mainDashBoarState, contentState, child) =>
                GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Column(
                  children: [
                    !mainDashBoarState.editPressedYello
                        ? NormalNavBar(
                            addMap: addMap,
                            sizeWidth: sizeWidth,
                            value: mainDashBoarState,
                            contentProvider: contentState,
                            menuController: MenuController(),
                          )
                        : EditWidget(
                            sizeWidth: sizeWidth,
                            controler: _mainDashBoard.boradTitleController,
                            value: mainDashBoarState,
                            contentProvider: contentState,
                          ),
                    GridViewWidget(
                      value: mainDashBoarState,
                      contentProvider: contentState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  final int count;
  final List<Map<String, dynamic>> content;
  const ListItems({
    super.key,
    required this.count,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => GestureDetector(
          onTap: content[index]["onTap"],
          child: Container(
            color: AppColor.shadowColor,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: Center(
              child: Text(
                content[index]["name"],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColor.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
