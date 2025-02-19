import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
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
    Future.delayed(const Duration(seconds: 5), () async {
      widget.value.setFindWordImage(false);

      if (widget.value.foundSuccess) {
        widget.value.clearFindTheWrongList();
        widget.value.setFoundSuccess(false);
        widget.value.setRandomIndex();
      } else {
        widget.value.speakForWrong();
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
                child: widget.value.isMobile
                    ? gridBoard(
                        value: widget.value,
                        contentProvider: widget.contentProvider,
                        fontSize: fontSize,
                        onTap: (title, index, grid) async {
                          if (widget.value.targetFindWord == title) {
                            await widget.value.flutterTts.speak(title);
                            widget.value.setFindWordImage(true);
                            widget.value.setFoundSuccess(true);
                            _onImageTap(MyAssets.correct);

                            Future.delayed(Duration(milliseconds: 3500), () {
                              // Show video in playing mode correct guessing
                              if (!widget.value.editPressedYello) {
                                if (grid.videosPath?.isNotEmpty ?? false) {
                                  var rand = Random().nextInt(
                                      grid.videosPath?.length ?? 0 + 1);

                                  dev.log(grid.videosPath!.length.toString());
                                  Navigator.pushNamed(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    RouteStrings.videoPlayer,
                                    arguments: grid.videosPath?[rand],
                                  );
                                } else {
                                  dev.log("Error occured no item  ");
                                }
                              }
                            });
                          } else {
                            widget.value.setFindTheWordWrongList(index);
                            widget.value.setFindWordImage(true);
                            _onImageTap(MyAssets.wrong);
                          }
                        },
                      )
                    : mainBoardList(
                        context: context,
                        value: widget.value,
                        contentProvider: widget.contentProvider,
                        fontSize: fontSize,
                        onTap: (title, index) async {
                          if (widget.value.targetFindWord == title) {
                            await widget.value.flutterTts.speak(title);
                            widget.value.setFindWordImage(true);
                            widget.value.setFoundSuccess(true);
                            _onImageTap(MyAssets.correct);
                          } else {
                            widget.value.setFindTheWordWrongList(index);
                            widget.value.setFindWordImage(true);
                            _onImageTap(MyAssets.wrong);
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
