// ignore_for_file: avoid_returning_null_for_void

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'dart:developer' as dev;
import 'package:path/path.dart' as p;

class ImageUploadWidget extends StatefulWidget {
  final File image;
  final VoidCallback onTap;
  final VoidCallback onTapRemove;
  final Color color;
  final double edgeInsetsGeometry;

  const ImageUploadWidget(
      {super.key,
      required this.image,
      required this.onTap,
      required this.onTapRemove,
      required this.color,
      required this.edgeInsetsGeometry});

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColor.borderColor3.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    widget.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: widget.onTapRemove,
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: const Center(
                          child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15,
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoUploadWidget extends StatefulWidget {
  final String video;
  final VoidCallback onTap;
  final VoidCallback onTapRemove;
  final bool isEditPressed;

  const VideoUploadWidget({
    super.key,
    required this.video,
    required this.onTap,
    required this.onTapRemove,
    required this.isEditPressed,
  });

  @override
  State<VideoUploadWidget> createState() => _VideoUploadWidgetState();
}

class _VideoUploadWidgetState extends State<VideoUploadWidget> {
  Uint8List? _thumbnailData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Agar video path change ho to dobara thumbnail generate karein
    if (widget.video != oldWidget.video) {
      _generateThumbnail();
    }
  }

  Future<void> _generateThumbnail() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _thumbnailData = null;
      });
    }

    if (widget.video.isEmpty) {
      dev.log('Video path is empty.', name: 'VideoThumbnail');
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      if (widget.video.startsWith('http')) {
        // --- Network Video (Cache ke saath) ---
        _thumbnailData = await _getThumbnailFromNetwork(widget.video);
      } else if (widget.video.startsWith('assets/')) {
        // --- Asset Video ---
        _thumbnailData = await _getThumbnailFromAsset(widget.video);
      } else {
        // --- File Video (Local Storage) ---
        _thumbnailData = await _getThumbnailFromFile(widget.video);
      }
    } catch (e) {
      dev.log('Failed to generate thumbnail for ${widget.video}: $e',
          name: 'VideoThumbnail');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Network video ke liye alag function (Bohat tez)
  Future<Uint8List?> _getThumbnailFromNetwork(String videoUrl) async {
    dev.log('Getting thumbnail from network: $videoUrl',
        name: 'VideoThumbnail');
    // Cache se file check karein
    final fileInfo = await DefaultCacheManager().getFileFromCache(videoUrl);
    String videoPath;

    if (fileInfo != null) {
      // Agar video cache mein hai to uska path use karein
      videoPath = fileInfo.file.path;
      dev.log('Video found in cache: $videoPath', name: 'VideoThumbnail');
    } else {
      // Agar nahi hai to download karein
      dev.log('Downloading video for thumbnail...', name: 'VideoThumbnail');
      final downloadedFile = await DefaultCacheManager().downloadFile(videoUrl);
      videoPath = downloadedFile.file.path;
    }

    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200,
      quality: 25,
    );
  }

  Future<Uint8List?> _getThumbnailFromAsset(String assetPath) async {
    dev.log('Getting thumbnail from asset: $assetPath', name: 'VideoThumbnail');
    File? tempFile;

    try {
      final tempDir = await getTemporaryDirectory();

      final String uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(assetPath)}';
      tempFile = File(p.join(tempDir.path, uniqueFileName));

      final byteData = await rootBundle.load(assetPath);
      await tempFile.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final thumbnail = await VideoThumbnail.thumbnailData(
        video: tempFile.path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 200,
        quality: 25,
      );

      return thumbnail;
    } catch (e) {
      dev.log('Error handling asset video: $e', name: 'VideoThumbnail');
      return null;
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
        dev.log('Temporary file cleaned up: ${tempFile.path}',
            name: 'VideoThumbnail');
      }
    }
  }

  // Local file video ke liye alag function
  Future<Uint8List?> _getThumbnailFromFile(String filePath) async {
    dev.log('Getting thumbnail from file: $filePath', name: 'VideoThumbnail');
    final file = File(filePath);
    if (!await file.exists()) {
      dev.log('File does not exist.', name: 'VideoThumbnail');
      return null;
    }
    return await VideoThumbnail.thumbnailData(
      video: filePath,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200, // Choti size rakhein taake jaldi ban jaye
      quality: 25, // Quality kam rakhein
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: context.height * 0.14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // widget.isEditPressed
              //     ? GestureDetector(
              //         onTap: widget.onTapRemove,
              //         child: Container(
              //           margin: const EdgeInsets.all(5),
              //           height: 30,
              //           width: 30,
              //           color: Colors.transparent,
              //           alignment: Alignment.topRight,
              //           child: Container(
              //             height: 20,
              //             width: 20,
              //             decoration: const BoxDecoration(
              //                 shape: BoxShape.circle, color: Colors.red),
              //             child: const Center(
              //                 child: Icon(
              //               Icons.close,
              //               color: Colors.white,
              //               size: 15,
              //             )),
              //           ),
              //         ),
              //       )
              //     : Container(),
              Expanded(
                child: Container(
                  height: context.height * 0.4,
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.borderColor3.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_isLoading)
                          Container(
                            color: Colors.grey[200],
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )
                        else if (_thumbnailData != null)
                          Image.memory(
                            _thumbnailData!,
                            fit: BoxFit.cover,
                          )
                        else
                          Container(
                            color: Colors.black,
                            child: Center(
                              child: Icon(
                                Icons.videocam_off, // No video icon
                                color: Colors.grey[400],
                                size: 40,
                              ),
                            ),
                          ),
                        const Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 40,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileUploadWidget extends StatefulWidget {
  final File file;
  final VoidCallback onTapRemove;

  const FileUploadWidget(
      {super.key, required this.file, required this.onTapRemove});

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              /*decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),*/
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        // image: DecorationImage( image: AssetImage(ImageString.uploadFile)),
                        color: AppColor.appPrimaryColor,
                        border: Border.all(color: AppColor.appPrimaryColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.file.path.split(".").last,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: AppColor.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.file.path.split("/").last,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 9),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: widget.onTapRemove,
                child: Container(
                  height: 30,
                  width: 30,
                  color: Colors.transparent,
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: const Center(
                        child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
