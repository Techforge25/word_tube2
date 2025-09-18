// ignore_for_file: avoid_returning_null_for_void

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Uint8List? generatedThumbnailData;
  bool isLoading = true;
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  Future<void> _generateThumbnail({File? file, String? assetPath}) async {
    try {
      String? videoPath;

      if (file != null) {
        // Case 1: Direct file (gallery/camera)
        dev.log("Using file path: ${file.path}");
        videoPath = file.path;
      } else if (assetPath != null) {
        // Case 2: Asset file → copy to temp directory first
        dev.log("Using asset path: $assetPath");

        final tempDir = await getTemporaryDirectory();
        final tempVideo = File('${tempDir.path}/temp_asset_video.mov');

        final byteData = await rootBundle.load(assetPath);
        await tempVideo.writeAsBytes(
          byteData.buffer.asUint8List(),
          flush: true,
        );

        videoPath = tempVideo.path;
      }

      if (videoPath == null) {
        dev.log("No valid video source provided!");
        return;
      }

      // Generate thumbnail
      final imageData = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.PNG,
        maxWidth: 256,
        maxHeight: 256,
        quality: 50,
      );

      if (imageData != null) {
        generatedThumbnailData = imageData;
        dev.log("Thumbnail generated successfully ✅");
      } else {
        dev.log("Thumbnail generation failed ❌");
      }
    } catch (e) {
      dev.log("Thumbnail error: $e");
    }
  }

  Future<void> _generateAndSetThumbnail() async {
    setLoading(true);

    if (widget.video.isEmpty) {
      dev.log('Video path is empty, cannot generate thumbnail.',
          name: 'VideoUploadWidget');
      setLoading(false);
      return;
    }

    String videoPathToThumbnail = widget.video;
    bool isAsset = widget.video.startsWith('assets/');

    if (isAsset) {
      try {
        final ByteData data = await rootBundle.load(widget.video);
        final List<int> bytes = data.buffer.asUint8List();
        final Directory tempDir = await getTemporaryDirectory();

        final String tempFileName =
            p.join(tempDir.path, p.basename(widget.video));
        final File tempFile = File(tempFileName);
        await tempFile.writeAsBytes(bytes);
        videoPathToThumbnail = tempFile.path;
        dev.log('Asset copied to temporary file: $videoPathToThumbnail',
            name: 'VideoUploadWidget');
      } catch (e) {
        dev.log('Error copying asset to temporary file: $e',
            name: 'VideoUploadWidget');
        setLoading(false);
        return;
      }
    } else {
      File videoFile = File(widget.video);
      if (!await videoFile.exists()) {
        dev.log('Video file does not exist at path: ${widget.video}',
            name: 'VideoUploadWidget');
        setLoading(false);
        return;
      }
      videoPathToThumbnail = videoFile.path; // Device file ka path hi use hoga
    }

    try {
      final Directory tempDirForThumb =
          await getTemporaryDirectory(); // Thumbnail ke liye bhi temp dir
      final String? thumbnailPath = await VideoThumbnail.thumbnailFile(
        video:
            videoPathToThumbnail, // Ab hum correct path use kar rahe hain (device file ya temp asset file)
        thumbnailPath: tempDirForThumb.path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 256,
        maxHeight: 256,
        quality: 50,
      );

      if (thumbnailPath != null) {
        generatedThumbnailData = await File(thumbnailPath).readAsBytes();
        dev.log('Thumbnail generated successfully for: ${widget.video}',
            name: 'VideoUploadWidget');
      } else {
        dev.log('Failed to generate thumbnail for: ${widget.video}',
            name: 'VideoUploadWidget');
      }
    } catch (e) {
      dev.log('Error generating thumbnail: $e', name: 'VideoUploadWidget');
    } finally {
      // Clean up temporary asset file if it was created
      if (isAsset && videoPathToThumbnail != widget.video) {
        try {
          await File(videoPathToThumbnail).delete();
          dev.log('Temporary asset file deleted: $videoPathToThumbnail',
              name: 'VideoUploadWidget');
        } catch (e) {
          dev.log('Error deleting temporary asset file: $e',
              name: 'VideoUploadWidget');
        }
      }
      setLoading(false);
    }
  }
  // Future generateThumbnail() async {
  //    Directory dir = await getApplicationCacheDirectory();
  //     var fileName = await VideoThumbnail.thumbnailData(
  //      video: widget.video,
  //      // thumbnailPath: (await getTemporaryDirectory()).path, /// path_provider
  //      imageFormat: ImageFormat.PNG,
  //      maxHeight: 50,
  //      quality: 50,
  //    );
  //
  //
  //    dev.log(fileName);
  //    if(fileName != null){
  //      setState(() {
  //        String decodedString = utf8.decode(fileName);
  //        generatedFile =decodedString;
  //
  //      });
  //    }
  //    dev.log(generatedFile);
  //    setLoading(false);
  //  }

  @override
  void initState() {
    // Future.microtask(() => _generateThumbnail(File(widget.video)));

    super.initState();
    _generateAndSetThumbnail();
    // _generateThumbnail(assetPath: (widget.video));
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
                        if (isLoading)
                          Container(
                            color: Colors.grey[200],
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )
                        else if (generatedThumbnailData != null)
                          Image.memory(
                            generatedThumbnailData!,
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
