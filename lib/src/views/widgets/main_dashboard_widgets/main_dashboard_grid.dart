import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/board/board.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/list.dart';
import '../../../app_providers/content_provider.dart';
import '../../../app_providers/main_dashboard_controller.dart';
import '../../../common/app_constants/assets.dart';
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
      duration: Duration(milliseconds: 600),
    );

    _animation = Tween<double>(
      begin: 0.1,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  // // Define the function that triggers the animation
  // void _onImageTap(String image) {
  //   widget.value.setFindWordImagePath(image);
  //   _controller.reset();
  //   _controller.forward();
  //   Future.delayed(const Duration(milliseconds: 1500), () async {
  //     widget.value.setFindWordImage(false);

  //     if (widget.value.foundSuccess) {
  //       widget.value.clearFindTheWrongList();
  //       widget.value.setFoundSuccess(false);
  //     } else {
  //       widget.value.speakForWrong();
  //     }
  //   });
  // }

  void _onImageTap(String image) {
    widget.value.setFindWordImagePath(image);
    _controller.reset();
    _controller.forward();

    if (widget.value.foundSuccess) {
      widget.value.playCorrectSound();
    } else {
      widget.value.speakForWrong();
    }

    // Thodi der baad image ko hide kar do
    Future.delayed(const Duration(milliseconds: 1500), () async {
      widget.value.setFindWordImage(false);

      if (widget.value.foundSuccess) {
        widget.value.clearFindTheWrongList();
        widget.value.setFoundSuccess(false);
      }
    });
  }

  bool isGridTapped = false;
  Future<void> _onGridTap(String title, int index, GridModel grid) async {
    if (isGridTapped) return; // Prevent multiple taps
    isGridTapped = true;

    if (widget.value.findTheWordWrongList.contains(index)) {
      isGridTapped = false;
      return;
    }
    if (title == "null" || title.isEmpty) {
      isGridTapped = false;
      return;
    }

    if (widget.value.targetFindWord == title) {
      widget.value.setFindWordImage(true);
      widget.value.setFoundSuccess(true);
      _onImageTap(MyAssets.correct);
      Future.delayed(const Duration(milliseconds: 1700), () async {
        if (!widget.value.editPressedYello) {
          if (grid.videosPath?.isNotEmpty ?? false) {
            var rand = Random().nextInt(grid.videosPath!.length);

            await widget.value.flutterTts.speak(title);

            Navigator.pushNamed(
              context,
              RouteStrings.videoPlayer,
              arguments: {
                'url': grid.videosPath?[rand],
                'localUrl': grid.localVideosPath?[rand],
              },
            ).then((_) {
              if (widget.value.findTheWord) {
                widget.value.setRandomIndex();
              }
            });
          } else {
            dev.log("Error: No video found");
            // Sirf word bolo agar video hi nahi hai
            await widget.value.flutterTts.speak(title);
            widget.value.setRandomIndex();
          }
        }
        isGridTapped = false;
      });
    } else {
      // ❌ Wrong case
      widget.value.setFindTheWordWrongList(index);
      widget.value.setFindWordImage(true);
      _onImageTap(MyAssets.wrong);
      isGridTapped = false;
    }
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
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          (widget
                                      .value
                                      .gridSizedModel
                                      .listData?[widget.value.randomListIndex]
                                      .title ==
                                  null)
                              ? "No items available. Please add items first."
                              : "Find '${widget.value.gridSizedModel.listData![widget.value.randomListIndex].title}'",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize),
                        )),
                    const Gap(5),
                  ],
                ),
              ),
              Expanded(
                child: widget.value.isMobile
                    ? gridBoard(
                        value: widget.value,
                        contentProvider: widget.contentProvider,
                        fontSize: fontSize,
                        onTap: _onGridTap,
                      )
                    : mainBoardList(
                        context: context,
                        value: widget.value,
                        contentProvider: widget.contentProvider,
                        fontSize: fontSize,
                        onTap: _onGridTap,
                      ),
              ),
            ],
          ),
          if (widget.value.findWordImage)
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                // Scale value for zoom
                scale: _animation,
                child: Image.asset(
                  widget.value.findWordImagePath,
                  width: 400,
                  height: 400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
