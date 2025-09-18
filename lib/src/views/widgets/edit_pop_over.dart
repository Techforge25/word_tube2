import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'package:word_toob/src/views/widgets/custom_bottom_sheet.dart';
import 'package:word_toob/src/views/widgets/custom_bottom_sheet_video.dart';
import 'package:word_toob/src/views/widgets/video_thumbnail_fleet.dart';
import 'dart:developer' as dev;

class EditPopOver extends StatefulWidget {
  final String title;
  final String picture;
  final int id;
  final int index;
  final int gridIndex;
  final bool hide;

  const EditPopOver({
    super.key,
    required this.title,
    required this.picture,
    required this.id,
    required this.index,
    required this.gridIndex,
    required this.hide,
  });

  @override
  State<EditPopOver> createState() => _EditPopOverState();
}

class _EditPopOverState extends State<EditPopOver> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(EditPopOver oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.title != oldWidget.title) {
      dev.log("This is title:  ${widget.title}");
    } else {
      dev.log("this is not updating---------->");
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.orientationOf(context);
    late double fontSize;
    if (orientation == Orientation.landscape) {
      fontSize = context.width * 0.02;
    } else {
      fontSize = context.height * 0.01;
    }

    dev.log('${widget.hide}');

    return Consumer2<MainDashboardController, ContentProvider>(
      builder: (context, mainDashboardController, contentProvider, child) =>
          SizedBox(
        height: context.height * 0.65,
        width: context.width * 0.75,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  GrayNavBarOnEdit(
                    widget: widget,
                    mainDashboardController: mainDashboardController,
                    contentProvider: contentProvider,
                    fontSize: fontSize,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const Gap(10),
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              const Gap(10),
                              mainDashboardController.isEditPressed
                                  ? SizedBox(
                                      width: context.width * 0.1,
                                      child: TextFormField(
                                        onTapOutside: (e) => FocusManager
                                            .instance.primaryFocus
                                            ?.unfocus(),

                                        style: TextStyle(
                                            fontSize: fontSize,
                                            color: AppColor.appPrimaryColor),

                                        controller: mainDashboardController
                                            .editTitleTextEditingController,
                                        // decoration: InputDecoration(),
                                      ),
                                    )
                                  : Text(
                                      widget.title == '' ? '?' : widget.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColor.appPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize,
                                          ),
                                    ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  if (mainDashboardController.isEditPressed) {
                                    mainDashboardController.toggleBottomSheet();
                                  }
                                },
                                child: widget.picture == "" &&
                                        mainDashboardController.imagePath == ''
                                    ? Container(
                                        width: context.width * 0.25,
                                        height: context.width * 0.25,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                        ),
                                      )
                                    : mainDashboardController.imagePath == ""
                                        ? widget.picture.contains("asset")
                                            ? Image.asset(
                                                widget.picture,
                                                height: context.width * 0.25,
                                                width: context.width * 0.25,
                                              )
                                            : Image.file(
                                                File(widget.picture),
                                                height: context.width * 0.25,
                                                width: context.width * 0.25,
                                              )
                                        : Image.file(
                                            File(mainDashboardController
                                                .imagePath),
                                            height: context.width * 0.25,
                                            width: context.width * 0.25,
                                          ),
                              ),
                              const Gap(10),
                              Visibility(
                                visible: mainDashboardController.isEditPressed,
                                child: GestureDetector(
                                  onTap: () {
                                    mainDashboardController.toggleBottomSheet();
                                  },
                                  child: Text(
                                    "Edit Picture",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColor.appPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize,
                                        ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              GestureDetector(
                                onTap: () async {
                                  mainDashboardController.hideOrShowEachGrid(
                                    contentProvider,
                                    widget.index,
                                    hideTitle: !widget.hide,
                                    hideImage: !widget.hide,
                                  );
                                  Navigator.pop(context);

                                  // await contentProvider.updateListDataItem(id: widget.id, itemIndex: widget.index,hideTitle:!widget.hide);
                                  // mainDashboardController.setGridSizedModel(contentProvider.allGridSizedModel[mainDashboardController.gridIndex],mainDashboardController.gridIndex);
                                  dev.log("This is being pressed");
                                },
                                child: Text(
                                  widget.hide == false
                                      ? "Hide Word"
                                      : "Unhide word",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColor.appPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: AppColor.shadowColor2,
                          thickness: 2,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              const Gap(10),
                              Text(
                                "${mainDashboardController.visibleVideos.length} Videos",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppColor.appPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize),
                              ),
                              const Gap(10),
                              Visibility(
                                visible: mainDashboardController.isEditPressed,
                                child: TextButton(
                                  onPressed: () => mainDashboardController
                                      .toggleBottomSheetVideo(),
                                  child: Text(
                                    "Add Videos",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: AppColor.shadowColor2,
                                thickness: 2,
                              ),
                              Column(
                                children: List.generate(
                                    mainDashboardController
                                        .visibleVideos.length, (index) {
                                  dev.log(
                                      "method called video length: ${mainDashboardController.visibleVideos.length}");
                                  final video = mainDashboardController
                                      .visibleVideos[index];
                                  if (mainDashboardController.isEditPressed) {
                                    return Slidable(
                                      key: ValueKey(video),
                                      // Use a unique key for each item, such as a video ID or index
                                      // direction: DismissDirection
                                      //     .startToEnd, // Swipe direction
                                      // background: Container(
                                      //   color: Colors
                                      //       .red, // Background color for the dismiss action
                                      //   alignment: Alignment.centerRight,
                                      //   padding: const EdgeInsets.only(right: 20),
                                      //   child: const Icon(Icons.delete,
                                      //       color: Colors.white),
                                      // ),
                                      // onDismissed: (direction) {

                                      // },
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        dismissible:
                                            DismissiblePane(onDismissed: () {
                                          mainDashboardController
                                              .removeVideosFromList(
                                            index,
                                            widget.gridIndex,
                                            widget.id,
                                            widget.index,
                                            contentProvider,
                                          );
                                        }),
                                        extentRatio: 0.25,
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              // Handle the removal of the video
                                              mainDashboardController
                                                  .removeVideosFromList(
                                                index,
                                                widget.gridIndex,
                                                widget.id,
                                                widget.index,
                                                contentProvider,
                                              );
                                            },
                                            backgroundColor: Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            flex: 1,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: VideoUploadWidget(
                                        isEditPressed: mainDashboardController
                                            .isEditPressed,
                                        onTapRemove: () =>
                                            mainDashboardController
                                                .removeVideosFromList(
                                          index,
                                          widget.gridIndex,
                                          widget.id,
                                          widget.index,
                                          contentProvider,
                                        ),
                                        video: video,
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          RouteStrings.videoPlayer,
                                          arguments: video,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return VideoUploadWidget(
                                      isEditPressed:
                                          mainDashboardController.isEditPressed,
                                      onTapRemove: () => mainDashboardController
                                          .removeVideosFromList(
                                        index,
                                        widget.gridIndex,
                                        widget.id,
                                        widget.index,
                                        contentProvider,
                                      ),
                                      video: video,
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        RouteStrings.videoPlayer,
                                        arguments: video,
                                      ),
                                    );
                                  }
                                }),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (mainDashboardController.showBottomSheetVideo)
              GestureDetector(
                onTap: () {
                  mainDashboardController.toggleBottomSheetOffVideo();
                },
                child: Container(
                  color: mainDashboardController.showBottomSheetVideo
                      ? AppColor.black.withOpacity(0.5)
                      : Colors.transparent,
                ),
              ),
            if (mainDashboardController.showBottomSheetVideo)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomBottomSheetVideo(
                  gridIndex: widget.gridIndex,
                  id: widget.id,
                  index: widget.index,
                ),
              ),
            if (mainDashboardController.showBottomSheet)
              GestureDetector(
                onTap: () {
                  mainDashboardController.toggleBottomSheetOff();
                },
                child: Container(
                  color: mainDashboardController.showBottomSheet
                      ? AppColor.black.withOpacity(0.5)
                      : Colors.transparent,
                ),
              ),
            if (mainDashboardController.showBottomSheet)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomBottomSheet(
                  gridIndex: widget.gridIndex,
                  id: widget.id,
                  index: widget.index,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GrayNavBarOnEdit extends StatelessWidget {
  final MainDashboardController mainDashboardController;
  final ContentProvider contentProvider;
  final double fontSize;

  const GrayNavBarOnEdit({
    super.key,
    required this.widget,
    required this.mainDashboardController,
    required this.contentProvider,
    required this.fontSize,
  });

  final EditPopOver widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColor.shadowColor2,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (mainDashboardController.isEditPressed)
            TextButton(
              onPressed: () async {
                mainDashboardController.isEditPressedFun(false);
                if (mainDashboardController
                    .editTitleTextEditingController.text.isNotEmpty) {
                  await contentProvider.updateListDataItem(
                      id: widget.id,
                      itemIndex: widget.index,
                      title: mainDashboardController
                          .editTitleTextEditingController.text);
                  mainDashboardController.setGridSizedModel(
                      contentProvider
                          .allGridSizedModel[mainDashboardController.gridIndex],
                      mainDashboardController.gridIndex);
                  mainDashboardController.clearEditTitleControllerText();
// ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Done",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColor.blue,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                mainDashboardController.isEditPressedFun(true);
                mainDashboardController
                    .setEditTitleControllerText(widget.title);
              },
              child: Text(
                "Edit",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColor.blue,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColor.appPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColor.blue,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
