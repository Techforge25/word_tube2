import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as dev;

import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/dependency_inject.dart';

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
  final _mainDashBoard = sl<MainDashboardController>();

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

    _controller.addListener(() async {
      if (!_hasNavigated &&
          _controller.value.position >= _controller.value.duration) {
        await Future.delayed(Duration(milliseconds: 1250), () {
          _hasNavigated = true;
          _mainDashBoard.isWatchingVideo = false;
          // Ensure this only happens once
// ignore: use_build_context_synchronously
          Navigator.of(context).pop();

          dev.log("going back----------->");
        });
      }
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
