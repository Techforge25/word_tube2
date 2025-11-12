import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:word_toob/src/services/firebase_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/general.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'dart:developer' as dev;

class CustomBottomSheetVideo extends StatefulWidget {
  final int id;
  final int index;
  final int gridIndex;
  const CustomBottomSheetVideo({
    super.key,
    required this.id,
    required this.index,
    required this.gridIndex,
  });

  @override
  State<CustomBottomSheetVideo> createState() => _CustomBottomSheetVideoState();
}

class _CustomBottomSheetVideoState extends State<CustomBottomSheetVideo> {
  Completer<void>? _cancelCompleter;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContentProvider, MainDashboardController>(
      builder: (context, contentProvider, controller, child) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: controller.isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LinearProgressIndicator(
                            value: controller.uploadProgress,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColor.blue),
                          ),
                          const Gap(8),
                          Text(
                            'Uploading... ${(controller.uploadProgress * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColor.blue),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            var video = await AppUtility.videoFromCamera();

                            if (video != null) {
                              _cancelCompleter = Completer<void>();
                              controller.setIsLoading(true);
                              controller.setUploadProgress(0.0);
                              printLog(
                                  "index of each grid model${widget.index}");
                              printLog(
                                  "index of each grid model: ${widget.index}");

                              final downloadUrl = await FirebaseStorageService()
                                  .uploadFile(video.path,
                                      'videos/${DateTime.now().millisecondsSinceEpoch}',
                                      onProgress: (progress) {
                                controller.setUploadProgress(progress);
                              }, cancelToken: _cancelCompleter!.future);

                              if (downloadUrl != null) {
                                controller.addVideoToList(downloadUrl);
                                await contentProvider.updateListDataItem(
                                    id: controller.gridSizedModel.id ?? -1,
                                    itemIndex: widget.index,
                                    videosPath: controller.videos);
                              }
                              controller.setIsLoading(false);
                              if (controller.gridIndex == widget.gridIndex) {
                                await controller.setGridSizedModel(
                                    contentProvider.allGridSizedModel[
                                        controller.gridIndex],
                                    controller.gridIndex);
                              }
                              controller.toggleBottomSheetOffVideo();
                            } else {
                              printLog(
                                  "Video picking cancelled or permission denied.");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 6),
                            child: Text(
                              'Take Video',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.blue),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              var video = await AppUtility.videoFromGallery();
                              if (video != null) {
                                _cancelCompleter = Completer<void>();
                                controller.setIsLoading(true);
                                controller.setUploadProgress(0.0);
                                dev.log(video.path, name: 'Video Path');

                                final downloadUrl =
                                    await FirebaseStorageService().uploadFile(
                                        video.path,
                                        'videos/${DateTime.now().millisecondsSinceEpoch}',
                                        onProgress: (progress) {
                                  controller.setUploadProgress(progress);
                                }, cancelToken: _cancelCompleter!.future);
                                if (downloadUrl != null) {
                                  controller.addVideoToList(downloadUrl);
                                  contentProvider.updateListDataItem(
                                      id: widget.id,
                                      itemIndex: widget.index,
                                      videosPath: controller.videos);
                                }
                                controller.setIsLoading(false);
                              }
                              if (controller.gridIndex == widget.gridIndex) {
                                controller.setGridSizedModel(
                                    contentProvider.allGridSizedModel[
                                        controller.gridIndex],
                                    controller.gridIndex);
                              }
                            } catch (e) {
                              print(e);
                              controller.setIsLoading(false);
                            } finally {
                              controller.setIsLoading(false);

                              controller.toggleBottomSheetOffVideo();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 6),
                            child: Text(
                              'Choose Existing',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.blue),
                            ),
                          ),
                        ),
                        const Gap(10),
                      ],
                    ),
            ),
            const Gap(3),
            GestureDetector(
              onTap: () {
                if (controller.isLoading) {
                  _cancelCompleter?.complete();
                }
                controller.toggleBottomSheetOffVideo();
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    ' Cancel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold, color: AppColor.blue),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
