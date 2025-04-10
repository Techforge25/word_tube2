import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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
    }

    if (mounted) {
      dev.log('i Poped');
      await _mainDashBoard.setRandomIndex();

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
    _controller.dispose();

    super.dispose();
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
      ),
    );
  }
}
