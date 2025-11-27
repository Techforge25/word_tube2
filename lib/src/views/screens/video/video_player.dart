import 'dart:io';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'dart:developer' as dev;

class VideoPlayerView extends StatefulWidget {
  final String url;
  final String? localUrl;
  const VideoPlayerView({super.key, required this.url, this.localUrl});

  @override
  VideoPlayerViewState createState() => VideoPlayerViewState();
}

class VideoPlayerViewState extends State<VideoPlayerView> {
  CachedVideoPlayerPlus? _controller;
  bool _hasNavigated = false;
  final _mainDashBoard = sl<MainDashboardController>();

  bool _isLoading = true;
  bool _hasError = false;
  final _contentProvider =
      sl<ContentProvider>(); // Get ContentProvider instance

  // Variables to hold data passed from MainDashboardController
  int? _currentGridItemIndex;
  int? _currentGridSizeModelId;

  @override
  void initState() {
    super.initState();

    _initController();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.localUrl != oldWidget.localUrl || widget.url != oldWidget.url) {
      _isLoading = true;
      _hasError = false;
      _controller?.dispose();
      _initController();
    }
  }

  Future<void> _initController() async {
    try {
      CachedVideoPlayerPlus newController;

      if (widget.localUrl != null &&
          widget.localUrl!.isNotEmpty &&
          await File(widget.localUrl!).exists()) {
        newController = CachedVideoPlayerPlus.file(File(widget.localUrl!));
      } else if (widget.url.contains("asset")) {
        newController = CachedVideoPlayerPlus.asset(widget.url);
      } else if (widget.url.startsWith('http')) {
        newController = CachedVideoPlayerPlus.networkUrl(Uri.parse(widget.url));
      } else {
        newController = CachedVideoPlayerPlus.file(File(widget.url));
      }

      await newController.initialize();

      // Jab sab kuch theek ho jaye, tab asal controller ko value dein aur UI update karein
      if (mounted) {
        setState(() {
          _controller = newController;
          _isLoading = false;
          _controller?.controller.play();

          // Listener ko yahan set karein
          _controller?.controller.addListener(() {
            if (_controller != null &&
                !_hasNavigated &&
                _controller!.controller.value.position >=
                    _controller!.controller.value.duration) {
              _hasNavigated = true;
              _mainDashBoard.isWatchingVideo = false;
              _onVideoEnd();
            }
          });
        });
      }
    } catch (e) {
      dev.log('$e', name: 'Video Error');
      // Agar error aaye to UI ko batayein
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _onVideoEnd() async {
    if (_mainDashBoard.speechToTextCheck) {
      _mainDashBoard.startListening(context);
      _mainDashBoard.isWatchingVideo = false;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _mainDashBoard.isWatchingVideo = false;

    _controller?.dispose();
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
      canPop: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        body: Stack(
          children: [
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator() // Jab tak loading ho rahi hai
                  : _hasError
                      ? const Text('Error playing video',
                          style:
                              TextStyle(color: Colors.white)) // Agar error aaye
                      : _controller != null && _controller!.isInitialized
                          ? AspectRatio(
                              // Jab sab tayyar ho
                              aspectRatio:
                                  _controller!.controller.value.aspectRatio,
                              child: VideoPlayer(_controller!.controller),
                            )
                          : const Text('Could not initialize video',
                              style: TextStyle(
                                  color: Colors.white)), // Ek fallback case
            ),
            Positioned(
              left: 50,
              top: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  _onVideoEnd();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_controller != null && _controller!.isInitialized) {
              setState(() {
                _controller!.controller.value.isPlaying
                    ? _controller!.controller.pause()
                    : _controller!.controller.play();
              });
            }
          },
          child: Icon(
            _controller != null &&
                    _controller!.isInitialized &&
                    _controller!.controller.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
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
