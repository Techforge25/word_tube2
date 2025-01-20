import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../app_providers/content_provider.dart';
import '../../../app_providers/main_dashboard_controller.dart';
import '../../../common/app_constants/assets.dart';
import '../../../common/app_constants/general.dart';
import '../../../common/app_constants/route_strings.dart';
import '../../../common/utils/common_functions.dart';
import '../../../source/models/grid_model.dart';
import '../../theme/app_color.dart';

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
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              const Gap(5),
              if (widget.value.findTheWord)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Find '${widget.value.gridSizedModel.listData?[widget.value.randomListIndex].title}'",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColor.black,
                        fontWeight: FontWeight.bold,
                        fontSize: context.height * 0.03),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  // shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.value.gridSizedModel.gridSizeY ?? 2,
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
                      return Stack(
                        children: [
                          Builder(
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
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 2,
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
                                        width: 2),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: context.height * 0.02,
                                          horizontal: context.width * 0.02),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            findTheWrongWord
                                                ? grid.title ?? '?'
                                                : "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: context.height *
                                                      0.028, // Adjust the font size if necessary
                                                ),
                                          ),
                                          SizedBox(
                                              height: context.height *
                                                  0.02), // Add spacing between text and image
                                          findTheWrongWord
                                              ? Flexible(
                                                  child: grid.imagepath != null
                                                      ? grid.imagepath!
                                                              .contains(
                                                                  "assets")
                                                          ? Image.asset(
                                                              grid.imagepath!,
                                                              height: context
                                                                      .height *
                                                                  0.5,
                                                              width: 100,
                                                            )
                                                          : Image.file(
                                                              File(grid
                                                                  .imagepath!),
                                                              height: context
                                                                      .height *
                                                                  0.5,
                                                              width: 100,
                                                            )
                                                      : Container(),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CommonFunctions.getCheckforGridShow(
                              isEditPressedYellow:
                                  widget.value.editPressedYello,
                              hideImage: grid.hideImage ?? false,
                              hideTitle: grid.hidetitle ?? false)
                          ? Builder(
                              builder: (context) => Stack(
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      widget.value.hideOrShowEachGrid(
                                          widget.contentProvider, index,
                                          hideTitle: true, hideImage: true);
                                    },
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
                                          gridIndex: widget.value.gridIndex);
                                      if (!widget.value.editPressedYello) {
                                        if (grid.videosPath?.isNotEmpty ??
                                            false) {
                                          widget.value.setLottie();
                                          widget.value.flutterTts
                                              .speak(grid.title ?? "");
                                          var rand = Random().nextInt(
                                              grid.videosPath?.length ?? 0 + 1);
                                          Navigator.pushNamed(
                                              context, RouteStrings.videoPlayer,
                                              arguments:
                                                  grid.videosPath?[rand]);
                                        } else {
                                          widget.value.setLottie();
                                          widget.value.flutterTts
                                              .speak(grid.title ?? "");

                                          printLog("Error occured no item  ");
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
                                              color: Colors.white, width: 2),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: context.height * 0.02,
                                                horizontal:
                                                    context.width * 0.02),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  grid.title ?? '?',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: AppColor.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: context
                                                                .height *
                                                            0.028, // Adjust the font size if necessary
                                                      ),
                                                ),
                                                SizedBox(
                                                    height: context.height *
                                                        0.02), // Add spacing between text and image
                                                if (widget.value
                                                        .settingsWordOnlyShow ==
                                                    1)
                                                  Flexible(
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
                                                                width: 100,
                                                              )
                                                            : Image.file(
                                                                File(grid
                                                                    .imagepath!),
                                                                height: context
                                                                        .height *
                                                                    0.5,
                                                                width: 100,
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
                                              widget.contentProvider, index,
                                              hideTitle: false,
                                              hideImage: false);
                                        },

                                        // onTap: () {
                                        //   widget.value.setItemOnEditState(
                                        //       hide: grid.hidetitle??false,
                                        //       gridIndex: widget.value.gridIndex,
                                        //       index,context,title: grid.title??"",
                                        //       picture:grid.imagepath??"",
                                        //       id:  widget.value.gridSizedModel.id??-1, videoPath: grid.videosPath??[]);
                                        //
                                        // },
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
