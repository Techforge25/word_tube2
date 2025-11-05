import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'dart:developer' as dev;

class VideoPlayerView extends StatefulWidget {
  final String url;
  const VideoPlayerView({super.key, required this.url});

  @override
  VideoPlayerViewState createState() => VideoPlayerViewState();
}

class VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  bool _hasNavigated = false;
  final _mainDashBoard = sl<MainDashboardController>();

  final _contentProvider =
      sl<ContentProvider>(); // Get ContentProvider instance

  // Variables to hold data passed from MainDashboardController
  int? _currentGridItemIndex;
  int? _currentGridSizeModelId;

  @override
  void initState() {
    super.initState();

    _initController().then((v) {
      if (v) {
        _controller.addListener(() {
          if (!_hasNavigated &&
              _controller.value.position >= _controller.value.duration) {
            _hasNavigated = true;
            _mainDashBoard.isWatchingVideo = false;

            _onVideoEnd();
          }
        });
      } else {
        _onVideoEnd();
      }
    });
  }

  Future<bool> _initController() async {
    try {
      // Check if the video is an asset or a file
      if (widget.url.contains("asset")) {
        _controller = VideoPlayerController.asset(
          widget.url,
          videoPlayerOptions: VideoPlayerOptions(),
        );
      } else if (widget.url.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.url),
          videoPlayerOptions: VideoPlayerOptions(),
        );
      } else {
        _controller = VideoPlayerController.file(
          File(widget.url),
          videoPlayerOptions: VideoPlayerOptions(),
        );
      }

      await _controller.initialize().then((v) {
        setState(() {
          _controller.play();
        });
      });

      return true;
    } catch (e) {
      dev.log('$e', name: 'Video Error');
      return false;
    }
  }

  Future<void> _onVideoEnd() async {
    if (_mainDashBoard.speechToTextCheck) {
// It will start the listening what the user says
      _mainDashBoard.startListening(context);
      _mainDashBoard.isWatchingVideo = false;
    }

    if (mounted) {
      // dev.log('i Poped');
      // await _mainDashBoard.setRandomIndex();

// ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed &&
//         _mainDashBoard.speechToTextCheck) {
// // It will start the listening what the user says
//       _mainDashBoard.startListening(context);
//     }
//   }

  @override
  void dispose() {
    if (_mainDashBoard.speechToTextCheck) {
// It will start the listening what the user says
      _mainDashBoard.startListening(context);
    }
    _mainDashBoard.isWatchingVideo = false;

    _controller.dispose();

    super.dispose();
  }

  Future<void> _recordAndAddVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);

    if (video != null) {
      // Check if we have the necessary IDs to link the video
      if (_currentGridSizeModelId != null && _currentGridItemIndex != null) {
        await _contentProvider.addVideoToGridItem(
          gridSizeModelId: _currentGridSizeModelId!,
          itemIndex: _currentGridItemIndex!,
          videoPath: video.path,
        );

        // Optionally, show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video added successfully!')),
        );

        // After adding the video, we can choose to pop the screen
        // or stay and allow further actions. Client's request implies
        // just adding it and continuing, so let's pop.
        Navigator.of(context).pop();
      } else {
        dev.log(
            "Error: GridSizeModel ID or GridItem Index is null. Cannot link video.",
            name: 'VideoPlayerView');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Could not link video to board/item.')),
        );
      }
    } else {
      dev.log("Video recording cancelled by user.", name: 'VideoPlayerView');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video recording cancelled.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: _controller.value.isInitialized
                    ? _controller.value.hasError
                        ? const Text('Error playing video')
                        : AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                VideoPlayer(_controller),
                                if (_controller.value.isBuffering)
                                  const CircularProgressIndicator(),
                              ],
                            ),
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

        // floatingActionButton: FloatingActionButton.extended(
        // onPressed: () async {
        //   // setState(() {
        //   //   _controller.value.isPlaying
        //   //       ? _controller.pause()
        //   //       : _controller.play();
        //   // });

        //   final picker = ImagePicker();
        //   final XFile? video = await picker.pickVideo(
        //       source: ImageSource.camera,
        //       maxDuration: const Duration(seconds: 30));

        //   if (video != null) {
        //     // ✅ Save video path into MainDashboardController
        //     _mainDashBoard.addVideoToList(video.path);

        //     if (mounted) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(
        //             content: Text("New video added successfully!")),
        //       );
        //     }
        //   }
        // },
        //   onPressed: _recordAndAddVideo,
        //   label: const Text("Add New Video"),
        //   icon: const Icon(Icons.video_camera_back),
        // ),
      ),
    );
  }
}
