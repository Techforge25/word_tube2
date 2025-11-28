import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:word_toob/src/services/firebase_storage_service.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import '../../app_providers/content_provider.dart';
import 'dart:developer' as dev;

class CustomBottomSheet extends StatefulWidget {
  final int id;
  final int index;
  final int gridIndex;
  const CustomBottomSheet({
    super.key,
    required this.id,
    required this.index,
    required this.gridIndex,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  Completer<void>? _cancelCompleter;

  @override
  Widget build(BuildContext context) {
    dev.log("Index at grid :${widget.index}");
    dev.log("List index  :${widget.gridIndex}");
    dev.log("id of   :${widget.gridIndex}");
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
                        GestureDetector(
                          onTap: () async {
                            var image = await AppUtility.imageFromCamera();
                            if (image != null) {
                              final compressedImage =
                                  await _compressImage(File(image.path));

                              // final localFile =
                              //     await AppUtility.saveImagePermanently(
                              //         compressedImage);

                              final localFile = compressedImage;

                              dev.log("Local file path: ${localFile.path}");
                              // Local path ko directly use karein (no cloud upload)
                              controller.getImagePath(localFile.path);
                              await contentProvider.updateListDataItem(
                                  id: controller.gridSizedModel.id ?? -1,
                                  itemIndex: widget.index,
                                  imagePath: localFile.path);

                              if (controller.gridIndex == widget.gridIndex) {
                                controller.setGridSizedModel(
                                    contentProvider
                                        .allGridSizedModel[widget.gridIndex],
                                    widget.gridIndex);
                              }
                              // printLog("Picked image path:"+image.path);
                              // printLog("Index at grid :"+index.toString());
                              // printLog("GridSizedModel Saved: "+contentProvider.allGridSizedModel[gridIndex].toJson().toString());

                              controller.toggleBottomSheetOff();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 6),
                            child: Text(
                              'Take Photo',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.blue),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              var image = await AppUtility.imageFromGallery();
                              if (image != null) {
                                // final compressedImage =
                                //     await _compressImage(File(image.path));
                                final localFile =
                                    await AppUtility.saveImagePermanently(
                                        File(image.path));

                                dev.log("Local file path: ${localFile.path}");
                                controller.getImagePath(localFile.path);
                                await contentProvider.updateListDataItem(
                                    id: widget.id,
                                    itemIndex: widget.index,
                                    imagePath: localFile.path);

                                if (controller.gridIndex == widget.gridIndex) {
                                  controller.setGridSizedModel(
                                      contentProvider
                                          .allGridSizedModel[widget.gridIndex],
                                      widget.gridIndex);
                                }
                              }
                            } catch (e) {
                              print("Error From Image Picker: $e");
                            } finally {
                              controller.setIsLoading(false);
                              controller.toggleBottomSheetOff();
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
                        // const Divider(),
                        // GestureDetector(
                        //   onTap: () async {
                        //     controller.getImagePath('');
                        //     await contentProvider.updateListDataItem(
                        //       id: widget.id,
                        //       itemIndex: widget.index,
                        //       imagePath: '',
                        //     );
                        //     controller.setGridSizedModel(
                        //         contentProvider
                        //             .allGridSizedModel[widget.gridIndex],
                        //         widget.gridIndex);
                        //     controller.toggleBottomSheetOff();
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 16.0, vertical: 6),
                        //     child: Text(
                        //       'Remove Image',
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .bodySmall
                        //           ?.copyWith(
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.red),
                        //     ),
                        //   ),
                        // ),
                        // const Gap(10),
                      ],
                    ),
            ),
            const Gap(3),
            GestureDetector(
              onTap: () {
                if (controller.isLoading) {
                  _cancelCompleter?.complete();
                }
                controller.toggleBottomSheetOff();
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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

  // Future<File> _compressImage(File file) async {
  //   final image = img.decodeImage(await file.readAsBytes());
  //   if (image == null) {
  //     return file;
  //   }

  //   final compressedImage = img.encodeJpg(image, quality: 85);
  //   final compressedFile = File('${file.path}_compressed.jpg')
  //     ..writeAsBytesSync(compressedImage);

  //   return compressedFile;
  // }

  Future<File> _compressImage(File file) async {
    final image = img.decodeImage(await file.readAsBytes());
    if (image == null) return file;

    final directory = await getApplicationDocumentsDirectory();
    final newName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final newPath = '${directory.path}/$newName';

    final compressedBytes = img.encodeJpg(image, quality: 85);
    final compressedFile = File(newPath);
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }
}
