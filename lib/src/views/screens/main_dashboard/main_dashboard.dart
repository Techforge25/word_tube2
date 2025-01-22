import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/app_strings.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'package:word_toob/src/views/widgets/Main%20Dashboard%20Widgets/main_dashboard_grid.dart';
import 'package:word_toob/src/views/widgets/Main%20Dashboard%20Widgets/nav_bar.dart';
import '../../../common/app_constants/general.dart';
import '../../../source/models/grid_size_model.dart';
import 'widget/button/edit.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> customDialogList = [
      {
        "name": "Emotions",
        "gridSizeX": 4,
        "gridSizeY": 4,
      },
      {
        "name": "First 25 Words",
        "gridSizeX": 5,
        "gridSizeY": 5,
      },
      {
        "name": "Alphabets",
        "gridSizeX": 5,
        "gridSizeY": 6,
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
        "gridSizeX": 10,
        "gridSizeY": 6,
      },
      {
        "name": "84 words",
        "gridSizeX": 12,
        "gridSizeY": 7,
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
        "onTap": () => _contentProvider.saveGridSizedModel(
              gridSizedModel: _mainDashBoard.duplicateGridSizedModel,
            )
      }
    ];

    double sizeWidth = context.width * 0.02;

    return SafeArea(
      child: Scaffold(
        body: Consumer2<MainDashboardController, ContentProvider>(
          builder: (context, mainDashBoarState, contentState, child) =>
              GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
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
