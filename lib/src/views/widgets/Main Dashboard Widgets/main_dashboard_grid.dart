import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../app_providers/content_provider.dart';
import '../../../app_providers/main_dashboard_controller.dart';
import '../../../common/app_constants/assets.dart';
import '../../../common/app_constants/route_strings.dart';
import '../../../common/utils/common_functions.dart';
import '../../../source/models/grid_model.dart';
import '../../theme/app_color.dart';
import 'dart:developer' as dev;

class GridViewWidget extends StatefulWidget {
  final MainDashboardController value;
  final ContentProvider contentProvider;
  const GridViewWidget({
    super.key,
    required this.value,
    required this.contentProvider,
  });

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.1, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  // Define the function that triggers the animation
  void _onImageTap(String image) {
    widget.value.setFindWordImagePath(image);
    _controller.reset();
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () async {
      widget.value.setFindWordImage(false);

      if (widget.value.foundSuccess) {
        widget.value.clearFindTheWrongList();
        widget.value.setFoundSuccess(false);
        widget.value.setRandomIndex();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late double fontSize;
    // late double iconSize;
    Orientation orientation = MediaQuery.orientationOf(context);
    if (orientation == Orientation.landscape) {
      if (context.height > 500) {
        fontSize = context.height * 0.025;
      } else {
        fontSize = (context.height * 0.025) + 4;
      }

      // iconSize = context.width * 0.025;
    } else {
      fontSize = context.height * 0.025;
      // iconSize = context.height * 0.04;
    }
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              const Gap(5),
              Visibility(
                visible: widget.value.findTheWord,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Find '${widget.value.gridSizedModel.listData?[widget.value.randomListIndex].title}'",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColor.black,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize + 4,
                        ),
                  ),
                ),
              ),
              const Gap(5),
              Expanded(
                child: GridView.builder(
                  // shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.value.gridSizedModel.gridSizeY ?? 4,
                    childAspectRatio: 1,
                  ),

                  itemCount: widget.value.gridSizedModel.listData?.length,
                  itemBuilder: (context, index) {
                    final GridModel grid =
                        widget.value.gridSizedModel.listData?[index] ??
                            GridModel();
                    final findTheWrongWord =
                        !widget.value.findTheWordWrongList.contains(index);

                    if (widget.value.findTheWord ||
                        widget.value.freePlay == false) {
                      return Builder(
                        builder: (context) => InkWell(
                          onTap: () {
                            if (widget.value.targetFindWord == grid.title) {
                              widget.value.setFindWordImage(true);
                              widget.value.setFoundSuccess(true);
                              _onImageTap(MyAssets.correct);
                            } else {
                              widget.value.setFindTheWordWrongList(index);
                              widget.value.setFindWordImage(true);
                              _onImageTap(MyAssets.wrong);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: findTheWrongWord
                                  ? AppColor.cardColor
                                  : AppColor.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: findTheWrongWord
                                    ? Colors.white
                                    : Colors.transparent,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
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
                                                ? grid.imagepath!
                                                        .contains("assets")
                                                    ? Image.asset(
                                                        grid.imagepath!,
                                                        height: context.height *
                                                            0.5,
                                                        width: context.height *
                                                            0.5,
                                                      )
                                                    : Image.file(
                                                        File(grid.imagepath!),
                                                        height: context.height *
                                                            0.5,
                                                        width: context.height *
                                                            0.5,
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
                    } else {
                      return CommonFunctions.getCheckforGridShow(
                        isEditPressedYellow: widget.value.editPressedYello,
                        hideImage: grid.hideImage ?? false,
                        hideTitle: grid.hidetitle ?? false,
                      )
                          ? Builder(
                              builder: (context) => Stack(
                                children: [
                                  GestureDetector(
                                    onLongPress: () =>
                                        widget.value.hideOrShowEachGrid(
                                      widget.contentProvider,
                                      index,
                                      hideTitle: true,
                                      hideImage: true,
                                    ),
                                    onTap: () {
                                      // value.setItemOnEditState(index,context,title: "Happy",picture: MyAssets.happy );
                                      widget.value.setItemOnEditState(
                                        hide: grid.hidetitle ?? false,
                                        index,
                                        context,
                                        title: grid.title ?? '',
                                        picture: grid.imagepath ?? "",
                                        id: widget.value.gridSizedModel.id ??
                                            -1,
                                        videoPath: grid.videosPath ?? [],
                                        gridIndex: widget.value.gridIndex,
                                      );

                                      widget.value.setLottie();
                                      widget.value.flutterTts
                                          .speak(grid.title ?? "");

                                      if (!widget.value.editPressedYello) {
                                        if (grid.videosPath?.isNotEmpty ??
                                            false) {
                                          var rand = Random().nextInt(
                                              grid.videosPath?.length ?? 0 + 1);

                                          dev.log(grid.videosPath!.length
                                              .toString());
                                          Navigator.pushNamed(
                                              context, RouteStrings.videoPlayer,
                                              arguments:
                                                  grid.videosPath?[rand]);
                                        } else {
                                          dev.log("Error occured no item  ");
                                        }
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColor.cardColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                widget.value.editPressedYello &&
                                                        (grid.videosPath
                                                                ?.isNotEmpty ??
                                                            false)
                                                    ? Colors.green
                                                    : Colors.white,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    grid.title ?? '?',
                                                    maxLines: 2,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: AppColor.white,
                                                          // Adjust the font size if necessary
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: fontSize,
                                                        ),
                                                  ),
                                                ),
                                                // Add spacing between text and image
                                                SizedBox(
                                                  height: context.height * 0.02,
                                                ),
                                                if (widget.value
                                                        .settingsWordOnlyShow ==
                                                    1)
                                                  Flexible(
                                                    flex: 3,
                                                    child: grid.imagepath !=
                                                            null
                                                        ? grid.imagepath!
                                                                .contains(
                                                                    "assets")
                                                            ? Image.asset(
                                                                grid.imagepath!,
                                                                height: context
                                                                        .height *
                                                                    0.5,
                                                                width: context
                                                                        .height *
                                                                    0.5,
                                                              )
                                                            : Image.file(
                                                                File(grid
                                                                    .imagepath!),
                                                                height: context
                                                                        .height *
                                                                    0.5,
                                                                width: context
                                                                        .height *
                                                                    0.5,
                                                              )
                                                        : Container(),
                                                  )
                                                else
                                                  Container(),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                  if (widget.value.editPressedYello &&
                                      grid.hideImage == true &&
                                      grid.hidetitle == true)
                                    Builder(
                                      builder: (context) => GestureDetector(
                                        onLongPress: () {
                                          widget.value.hideOrShowEachGrid(
                                            widget.contentProvider,
                                            index,
                                            hideTitle: false,
                                            hideImage: false,
                                          );
                                        },
                                        onTap: () {
                                          widget.value.setItemOnEditState(
                                              hide: grid.hidetitle ?? false,
                                              gridIndex: widget.value.gridIndex,
                                              index,
                                              context,
                                              title: grid.title ?? "",
                                              picture: grid.imagepath ?? "",
                                              id: widget.value.gridSizedModel
                                                      .id ??
                                                  -1,
                                              videoPath: grid.videosPath ?? []);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColor.lightBlue
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            // border: Border.all(color: Colors.white, width: 2),
                                          ), // Light blue overlay with opacity
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : Container();
                    }
                  },
                ),
              ),
            ],
          ),
          if (widget.value.findWordImage)
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: _animation, // Scale value for zoom
                child: Image.asset(
                  widget.value.findWordImagePath,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
