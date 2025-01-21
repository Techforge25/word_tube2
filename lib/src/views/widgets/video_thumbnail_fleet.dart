// ignore_for_file: avoid_returning_null_for_void

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'dart:developer' as dev;

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
  Uint8List? generatedFile;
  bool isLoading = true;
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  // ignore: unused_element
  Future<void> _generateThumbnail(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    try {
      dev.log('exists ${file.existsSync()}');

      dev.log('tempPath ${directory.path}');
      var imageData = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 256,
        maxHeight: 256,
        quality: 50,
      );

      dev.log('$imageData');
      if (imageData != null) {
        setState(() {
          generatedFile = imageData;
        });
      }
    } catch (e) {
      dev.log('$e');
      // eventBus.fire(showToast(CommonUtils.getLocale(null).noThumbnail));
      return null;
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
    // Future.microtask(()=> _generateThumbnail(File(widget.video)));
    super.initState();
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
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.borderColor3.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black,
                        ),
                        const Positioned.fill(
                            child: Icon(
                          Icons.play_circle,
                          size: 30,
                        ))
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

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.url});
  final String url;

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Check if the video is an asset or a file
    if (widget.url.contains("asset")) {
      _controller = VideoPlayerController.asset(widget.url,
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          setState(() {
            _controller.play();
          });
        });
    } else {
      _controller = VideoPlayerController.file(File(widget.url),
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          setState(() {
            _controller.play();
          });
        });
    }

    _controller.addListener(() {
      setState(() {
        if (!_hasNavigated &&
            _controller.value.position >= _controller.value.duration) {
          Navigator.of(context).pop();
          _hasNavigated = true; // Ensure this only happens once
          dev.log("going back----------->");
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),
            ),
            // IconButton(
            //   onPressed: (){
            //     Navigator.of(context).pop();
            //   },
            //   icon: Container(
            //
            //     padding: const EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //         color: Colors.grey[300]!.withOpacity(0.4),
            //         borderRadius: BorderRadius.circular(200)
            //     ),
            //     child: Icon(Icons.arrow_back,
            //         size: 10,
            //         color: Theme.of(context).inputDecorationTheme.iconColor),
            //   ),
            // ),
            // Center(
            //   child: IconButton(
            //     onPressed: (){
            //       Navigator.of(context).pop();
            //     },
            //     icon: Container(
            //
            //       padding: const EdgeInsets.all(5),
            //       decoration: BoxDecoration(
            //           color: Colors.grey[300]!,
            //           borderRadius: BorderRadius.circular(200)
            //       ),
            //       child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            //           size: 20,
            //           color: Theme.of(context).inputDecorationTheme.iconColor),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
