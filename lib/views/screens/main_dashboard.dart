import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:word_toob/app_providers/content_provider.dart';
import 'package:word_toob/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/common/app_constants/app_strings.dart';
import 'package:word_toob/common/utils/app_utility.dart';
import 'package:word_toob/dependency_inject.dart';
import 'package:word_toob/source/models/grid_model.dart';
import 'package:word_toob/views/theme/app_color.dart';
import 'package:word_toob/views/widgets/Main%20Dashboard%20Widgets/main_dashboard_grid.dart';
import 'package:word_toob/views/widgets/Main%20Dashboard%20Widgets/nav_bar.dart';
import 'package:word_toob/views/widgets/bottom_sheet.dart';
import 'package:word_toob/views/widgets/custom_menu_widget.dart';

import '../../common/app_constants/app_keys.dart';
import '../../common/app_constants/general.dart';
import '../../source/models/grid_size_model.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // ignore: prefer_final_fields
  TextEditingController _controler = TextEditingController();

  final _contentProvider = sl<ContentProvider>();
  final _mainDashBoard = sl<MainDashboardController>();

  void saveData() {
    _contentProvider.saveAllGridSizedModel(
        gridSizedModelList: gridModelList, contenProvider: _contentProvider);
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
        "onTap": () {
          _contentProvider.saveGridSizedModel(
            gridSizedModel: _mainDashBoard.duplicateGridSizedModel,
          );
        }
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
                        controler: _controler,
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

class LeftRow extends StatelessWidget {
  const LeftRow({
    super.key,
    required this.addMap,
    required this.iconSize,
    required this.sizeWidth,
    required this.menuController2,
    required this.contentProvider,
    required this.value,
    required this.fontSize,
  });

  final List<Map<String, dynamic>> addMap;
  final double iconSize;
  final double sizeWidth;
  final MenuController menuController2;
  final ContentProvider contentProvider;
  final MainDashboardController value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlusButton(
          addMap: addMap,
          iconSize: iconSize,
          fontSize: fontSize,
        ),
        Gap(sizeWidth),
        MyBoardsButton(
          menuController: menuController2,
          contentProvider: contentProvider,
          value: value,
          fontSize: fontSize,
        ),
        Gap(sizeWidth),
        IconButton(
          onPressed: () => value.setSpeechToText(context),
          splashRadius: 100,
          icon: Container(
            decoration: BoxDecoration(
              color:
                  value.speechToTextCheck ? AppColor.blue : Colors.transparent,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(5),
            child: Icon(
              Icons.mic,
              size: iconSize,
              color: value.speechToTextCheck ? AppColor.white : AppColor.blue,
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     value.setSpeechToText(context);
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color:
        //           value.speechToTextCheck ? AppColor.blue : Colors.transparent,
        //       shape: BoxShape.circle,
        //     ),
        //     padding: const EdgeInsets.all(5),
        //     child: Icon(
        //       Icons.mic,
        //       size: iconSize,
        //       color: value.speechToTextCheck ? AppColor.white : AppColor.blue,
        //     ),
        //   ),
        // ),
        Gap(sizeWidth),
        if (value.lottie || value.speechToTextCheck)
          Lottie.asset(
            'assets/v_player.json',
            animate: value.lottie || value.speechToTextCheck,
          ),
      ],
    );
  }
}

class CenterTitle extends StatelessWidget {
  const CenterTitle({
    super.key,
    required this.value,
    required this.fontSize,
  });

  final MainDashboardController value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(value.gridSizedModel.title ?? "",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize)),
    );
  }
}

class PlusButton extends StatelessWidget {
  final List<Map<String, dynamic>> addMap;
  final double iconSize;
  final double fontSize;

  const PlusButton({
    super.key,
    required this.addMap,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
        menuItems: List.generate(
            addMap.length,
            (index) => GestureDetector(
                  onTap: addMap[index]["onTap"],
                  child: ListTile(
                    tileColor:
                        index == 0 ? AppColor.shadowColor : AppColor.white,
                    title: Text(
                      addMap[index]["name"],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColor.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                    ),
                  ),
                )),
        titleWidget: Icon(
          Icons.add,
          size: iconSize,
        ));
  }
}

class MyBoardsButton extends StatelessWidget {
  const MyBoardsButton({
    super.key,
    required this.menuController,
    required this.contentProvider,
    required this.value,
    required this.fontSize,
  });

  final MenuController menuController;
  final ContentProvider contentProvider;
  final MainDashboardController value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
      menuController: menuController,
      menuItems:
          List.generate(contentProvider.allGridSizedModel.length, (index) {
        return ListTile(
          onTap: () {
            value.setGridSize(
                contentProvider.allGridSizedModel[index].gridSizeX ?? 1,
                contentProvider.allGridSizedModel[index].gridSizeY ?? 2);
            value.setGridSizedModel(
                contentProvider.allGridSizedModel[index], index);
            printLog("${index}it is index");

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

class RightRow extends StatelessWidget {
  const RightRow({
    super.key,
    required this.menuController,
    required this.gameMap,
    required this.fontSize,
    required this.sizeWidth,
    required this.value,
    required this.gap,
  });

  final MenuController menuController;
  final List<Map<String, dynamic>> gameMap;
  final double fontSize;
  final double sizeWidth;
  final MainDashboardController value;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomMenuAnchor(
          menuController: menuController,
          menuItems: List.generate(2, (index) {
            return ListTile(
              onTap: gameMap[index]["onTap"],
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              title: Text(
                gameMap[index]["name"],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: fontSize + 4,
                      color: AppColor.appPrimaryColor.withOpacity(0.5),
                    ),
              ),
            );
          }),
          titleWidget: Text(
            "Games",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Gap(sizeWidth),
        GestureDetector(
          onTap: () {
            value.setEdit(true);
          },
          child: Text("Edit",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
        ),
        Gap(sizeWidth),
        SettingButton(
          fontSize: fontSize,
          gap: gap,
          value: value,
          gameMenuController: menuController,
        ),
        Gap(sizeWidth),
        HelpButton(fontSize: fontSize),
      ],
    );
  }
}

class HelpButton extends StatelessWidget {
  const HelpButton({
    super.key,
    required this.fontSize,
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => BottomSheetContent(),
        );
      },
      child: Text("Help",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize)),
    );
  }
}

class SettingButton extends StatefulWidget {
  final double fontSize;
  final MenuController gameMenuController;
  final double gap;
  final MainDashboardController value;

  const SettingButton({
    super.key,
    required this.fontSize,
    required this.gap,
    required this.value,
    required this.gameMenuController,
  });

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
      menuController: menuController,
      menuItems: [
        CustomMenuItemButton(
          child: Container(
            width: context.width * 0.35,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: widget.fontSize + 5,
                          fontWeight: FontWeight.w800,
                          color: AppColor.appPrimaryColor,
                        ),
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(25),
                      Text(
                        "Tiles",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: widget.fontSize + 4,
                              color: AppColor.appPrimaryColor.withOpacity(0.5),
                            ),
                      ),
                      Gap(widget.gap),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.value.wordsOnlyShowSettings(1);
                                menuController.close();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Symbols & Word",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: widget.fontSize + 4,
                                            color: AppColor.appPrimaryColor,
                                          ),
                                    ),
                                  ),
                                  widget.value.settingsWordOnlyShow == 1
                                      ? const Icon(
                                          Icons.check,
                                          color: AppColor.green,
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Gap(widget.gap),
                            GestureDetector(
                              onTap: () {
                                widget.value.wordsOnlyShowSettings(2);
                                menuController.close();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Word Only",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: widget.fontSize + 4,
                                            color: AppColor.appPrimaryColor,
                                          ),
                                    ),
                                  ),
                                  widget.value.settingsWordOnlyShow == 2
                                      ? const Icon(
                                          Icons.check,
                                          color: AppColor.green,
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(widget.gap),

                      //
                      // Text("SPEECH OUTPUT",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //     fontSize: fontSize+5,
                      //     color:AppColor.appPrimaryColor.withOpacity(0.5)
                      // )),
                      // Gap(gap),
                      //
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Use Speech",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //           Switch(
                      //             activeColor: AppColor.white,
                      //               activeTrackColor: AppColor.green,
                      //               value: value.useSpeech, onChanged: (valueNew){
                      //               value.useSpeechFunction();
                      //
                      //           })
                      //         ],
                      //       ),
                      //       Gap(10),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //
                      //         children: [
                      //           Text("Voice",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )),
                      //           Text("English (United States)",
                      //               maxLines: 2,
                      //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+5,
                      //
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //
                      //
                      //         ],
                      //       ),
                      //
                      //
                      //
                      //
                      //
                      //
                      //     ],
                      //   ),
                      // ),
                      // Gap(gap),
                      //
                      // Text("SPEECH RECOGNITION",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //     fontSize: fontSize+5,
                      //     color:AppColor.appPrimaryColor.withOpacity(0.5)
                      // )),
                      // Gap(gap),
                      //
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("English ",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //           Icon(Icons.check,color: AppColor.green,)
                      //         ],
                      //       ),
                      //       Gap(gap),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //
                      //         children: [
                      //           Text("Spanish",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //           Icon(Icons.check,color: AppColor.green,)
                      //
                      //         ],
                      //       ),
                      //
                      //
                      //
                      //     ],
                      //   ),
                      // ),
                      // Gap(gap),

                      // Text("GAME OPTIONS",
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .bodyMedium
                      //         ?.copyWith(
                      //             fontSize: widget.fontSize + 8,
                      //             color: AppColor.appPrimaryColor
                      //                 .withOpacity(0.5))),
                      // Gap(widget.gap),

                      // GestureDetector(
                      //   onTap: () {
                      //     menuController.close();
                      //     widget.gameMenuController.open();
                      //   },
                      //   child: Text("Find The Word",
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodyMedium
                      //           ?.copyWith(
                      //               fontSize: widget.fontSize + 10,
                      //               color: AppColor.appPrimaryColor
                      //                   .withOpacity(0.5))),
                      // ),
                      // Gap(widget.gap),

                      GestureDetector(
                        onTap: () {
                          menuController.close();
                          Share.share('Welcome to Word Toob! 📚✨ \n'
                              'Whether you’re a beginner or an expert, Word Toob makes learning languages fun and addictive! 🌍🎉 \n'
                              'Download now and join the adventure: ${AppKeys.appStore}\n'
                              'For more info visit: http://wordtoob.com/index.html');
                        },
                        child: Text(
                          "Share",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: widget.fontSize + 4,
                                color:
                                    AppColor.appPrimaryColor.withOpacity(0.5),
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
      titleWidget: Text("Settings",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
    );
  }
}

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
