import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';

import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'dart:developer' as dev;
import 'package:word_toob/src/views/theme/app_color.dart';

Widget basicGrid({
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required GridModel grid,
  required int index,
  required double fontSize,
  double? size,
  required double screenWidth,
  required double screenHeight,
  bool isFor84And64Grid = false,
}) {
  return Builder(
    builder: (context) => Stack(
      children: [
        InkWell(
          onLongPress: () => value.hideOrShowEachGrid(
            contentProvider,
            index,
            hideTitle: true,
            hideImage: true,
          ),
          onTap: () async {
            if (value.isTapped) return;
            value.setIsTapped(true);
            if (value.speechToTextCheck) {
              value.stopListening();
            }

            // Safely handle missing image - check if imagepath exists and is valid
            String picturePath = "";
            try {
              dev.log("Image path: ${grid.imagepath}");
              if (grid.imagepath != null &&
                  grid.imagepath!.isNotEmpty &&
                  grid.imagepath! != "null") {
                // HTTP ya asset paths ko directly use karo
                if (grid.imagepath!.startsWith("http") ||
                    grid.imagepath!.startsWith("assets") ||
                    grid.imagepath!.startsWith("asset")) {
                  picturePath = grid.imagepath!;
                } else {
                  // Local file path hai - filename extract karke global path ke saath concatenate karo
                  final fullPath =
                      await AppUtility.getFullPath(grid.imagepath!);
                  final file = File(fullPath);
                  if (await file.exists()) {
                    picturePath = fullPath;
                  } else {
                    // Agar file exist nahi karti, original path try karo
                    picturePath = grid.imagepath!;
                  }
                }
              }
            } catch (e) {
              dev.log('Error checking image path: $e', name: 'Grid Normal');
              picturePath = "";
            }

            // value.setItemOnEditState(index,context,title: "Happy",picture: MyAssets.happy );
            await value.flutterTts.speak(grid.title ?? "");
            await Future.delayed(Duration(milliseconds: 500));
            value.setItemOnEditState(
              hide: grid.hidetitle ?? false,
              index,
              context,
              title: grid.title ?? '',
              picture: picturePath, // Use validated picture path
              id: value.gridSizedModel.id ?? -1,
              videoPath: grid.videosPath ?? [],
              gridIndex: value.gridIndex,
            );

            if (!value.editPressedYello) {
              if (grid.videosPath?.isNotEmpty ?? false) {
                final videos = grid.videosPath!;
                final localVideos = grid.localVideosPath;
                final rand = Random().nextInt(videos.length);

                dev.log('Total videos: ${videos.length} $rand video index');

                // Video URL bhi check karo - agar local file hai to global path use karo
                String videoUrl = videos[rand];
                bool isNetworkUrl = videoUrl.startsWith("http");
                bool isAssetFile = videoUrl.startsWith("assets") ||
                    videoUrl.startsWith("asset");

                String? localUrl;
                // Sirf tab localUrl set karo jab selected video network URL ya asset file nahi hai
                // Agar network URL ya asset file hai to localUrl null rahega taaki wo video play ho
                if (!isNetworkUrl && !isAssetFile) {
                  // Ye sirf local file paths ke liye hai
                  if (localVideos != null &&
                      localVideos.isNotEmpty &&
                      rand < localVideos.length) {
                    // Filename extract karke global path ke saath concatenate karo
                    final fullLocalPath =
                        await AppUtility.getFullPath(localVideos[rand]);
                    final file = File(fullLocalPath);
                    if (await file.exists()) {
                      localUrl = fullLocalPath;
                    } else {
                      localUrl = localVideos[rand];
                    }
                  }

                  // Agar video URL local file hai to global path use karo
                  final fullVideoPath = await AppUtility.getFullPath(videoUrl);
                  final file = File(fullVideoPath);
                  if (await file.exists()) {
                    videoUrl = fullVideoPath;
                  }
                }

                Navigator.pushNamed(
                  context,
                  RouteStrings.videoPlayer,
                  arguments: {
                    'url': videoUrl,
                    'localUrl': localUrl,
                  },
                ).then((_) => value.setIsTapped(false));
              } else {
                dev.log("Error occured no item  ");
                value.setIsTapped(false);
              }
            } else {
              value.setIsTapped(false);
            }
          },
          child: (isFor84And64Grid)
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  //padding: EdgeInsets.symmetric(horizontal: 1.5),
                  height: double.maxFinite,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: grid.videosPath?.isNotEmpty ?? false
                          ? Colors.green
                          : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(grid.title ?? '?',
                          style: TextStyle(fontSize: fontSize / 1.2)),
                      // Add spacing between text and image
                      SizedBox(height: context.height * 0.008),
                      if (value.settingsWordOnlyShow == 1)
                        Flexible(
                          child: grid.imagepath != null &&
                                  grid.imagepath!.isNotEmpty
                              ? grid.imagepath!.startsWith("http")
                                  ? CachedNetworkImage(
                                      imageUrl: grid.imagepath!,
                                      height: screenHeight * 0.1,
                                      width: screenHeight * 0.12,
                                      fit: BoxFit.contain,
                                    )
                                  : grid.imagepath!.startsWith("assets")
                                      ? Image.asset(
                                          grid.imagepath!,
                                          height: screenHeight * 0.1,
                                          width: screenHeight * 0.12,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.file(
                                          File(grid.imagepath!),
                                          height: screenHeight * 0.1,
                                          width: screenHeight * 0.12,
                                          fit: BoxFit.contain,
                                        )
                              : Container(),
                        )
                      else
                        Container(),
                    ],
                  ))
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: grid.videosPath?.isNotEmpty ?? false
                          ? Colors.green
                          : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.height * 0.01,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            grid.title ?? '?',
                            maxLines: 2,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColor.white,
                                      // Adjust the font size if necessary

                                      fontSize: fontSize,
                                    ),
                          ),
                          // Add spacing between text and image
                          SizedBox(height: context.height * 0.008),
                          if (value.settingsWordOnlyShow == 1)
                            Flexible(
                              child: grid.imagepath != null &&
                                      grid.imagepath!.isNotEmpty
                                  ? grid.imagepath!.startsWith("http")
                                      ? CachedNetworkImage(
                                          imageUrl: grid.imagepath!,
                                          height: context.height * 0.5,
                                          width: context.height * 0.5,
                                        )
                                      : grid.imagepath!.startsWith("assets")
                                          ? Image.asset(
                                              grid.imagepath!,
                                              height: context.height * 0.5,
                                              width: context.height * 0.5,
                                            )
                                          : Image.file(
                                              File(AppUtility
                                                  .getFullPathFromFileName(
                                                      grid.imagepath!)),
                                              height: context.height * 0.5,
                                              width: context.height * 0.5,
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
        if (value.editPressedYello &&
            grid.hideImage == true &&
            grid.hidetitle == true)
          Builder(
            builder: (context) => GestureDetector(
              onLongPress: () {
                value.hideOrShowEachGrid(
                  contentProvider,
                  index,
                  hideTitle: false,
                  hideImage: false,
                );
              },
              onTap: () {
                value.setItemOnEditState(
                    hide: grid.hidetitle ?? false,
                    gridIndex: value.gridIndex,
                    index,
                    context,
                    title: grid.title ?? "",
                    picture: grid.imagepath ?? "",
                    id: value.gridSizedModel.id ?? -1,
                    videoPath: grid.videosPath ?? []);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColor.lightBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: Colors.white, width: 2),
                ), // Light blue overlay with opacity
              ),
            ),
          ),
      ],
    ),
  );
}

/// Normal Grid View
/* Container(
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: grid.videosPath?.isNotEmpty ?? false
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
                  child: Stack(
                    children: [
                      if (grid.imagepath != null)
                        Positioned.fill(
                          child: grid.imagepath!.contains("assets")
                              ? Image.asset(
                                  grid.imagepath!,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(grid.imagepath!),
                                  fit: BoxFit.contain,
                                ),
                        ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Text(
                          grid.title ?? '?',
                          maxLines: 2,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        */
