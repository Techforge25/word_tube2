import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/board/board.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/list.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/assets.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

import 'dart:developer' as dev;

/// Main grid view widget for the dashboard
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
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.1, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handle image tap animation and feedback
  void _onImageTap(String image) {
    widget.value.setFindWordImagePath(image);
    _controller.reset();
    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () async {
      widget.value.setFindWordImage(false);

      if (widget.value.foundSuccess) {
        widget.value.clearFindTheWrongList();
        widget.value.setFoundSuccess(false);
      } else {
        widget.value.speakForWrong();
      }
    });
  }

  /// Handle grid item tap with game logic
  Future<void> _onGridTap(String title, int index, GridModel grid) async {
    if (widget.value.targetFindWord == title) {
      await _handleCorrectGuess(title, grid);
    } else {
      _handleWrongGuess(index);
    }
  }

  /// Handle correct word guess
  Future<void> _handleCorrectGuess(String title, GridModel grid) async {
    await widget.value.flutterTts.speak(title);
    widget.value.setFindWordImage(true);
    widget.value.setFoundSuccess(true);
    _onImageTap(MyAssets.correct);

    Future.delayed(const Duration(milliseconds: 3500), () {
      _playVideoIfAvailable(grid);
    });
  }

  /// Play video if available for correct guess
  void _playVideoIfAvailable(GridModel grid) {
    if (!widget.value.editPressedYello) {
      if (grid.videosPath?.isNotEmpty ?? false) {
        final rand = Random().nextInt(grid.videosPath?.length ?? 0 + 1);
        dev.log(grid.videosPath!.length.toString());

        Navigator.pushNamed(
          context,
          RouteStrings.videoPlayer,
          arguments: grid.videosPath?[rand],
        );
      } else {
        dev.log("Error occurred: no video available");
        widget.value.setRandomIndex();
      }
    }
  }

  /// Handle wrong word guess
  void _handleWrongGuess(int index) {
    widget.value.setFindTheWordWrongList(index);
    widget.value.setFindWordImage(true);
    _onImageTap(MyAssets.wrong);
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = _calculateFontSize(context);

    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              const Gap(5),
              _buildFindWordText(fontSize),
              const Gap(5),
              Expanded(
                child: _buildGridContent(fontSize),
              ),
            ],
          ),
          _buildFindWordImage(),
        ],
      ),
    );
  }

  /// Build the "Find Word" instruction text
  Widget _buildFindWordText(double fontSize) {
    return Visibility(
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
    );
  }

  /// Build the main grid content based on device type
  Widget _buildGridContent(double fontSize) {
    if (widget.value.isMobile) {
      return gridBoard(
        value: widget.value,
        contentProvider: widget.contentProvider,
        fontSize: fontSize,
        onTap: _onGridTap,
      );
    } else {
      return mainBoardList(
        context: context,
        value: widget.value,
        contentProvider: widget.contentProvider,
        fontSize: fontSize,
        onTap: _onGridTap,
      );
    }
  }

  /// Build the find word image overlay
  Widget _buildFindWordImage() {
    if (!widget.value.findWordImage) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset(
          widget.value.findWordImagePath,
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  /// Calculate font size based on orientation and context
  double _calculateFontSize(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);

    if (orientation == Orientation.landscape) {
      if (context.height > 500) {
        return context.height * 0.025;
      } else {
        return (context.height * 0.025) + 4;
      }
    } else {
      return context.height * 0.025;
    }
  }
}
