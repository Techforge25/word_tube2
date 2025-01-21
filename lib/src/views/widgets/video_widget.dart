import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// ignore: must_be_immutable
class VideoThumbnail extends StatefulWidget {
  String videoPath;
  VideoThumbnail(this.videoPath, {super.key});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {}); // when the thumbnail will show.
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoInitialize: true,
      autoPlay: true,
      showOptions: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: InkWell(
        child: _controller.value.isInitialized
            ? GestureDetector(
                onTap: () {},
                child: Chewie(controller: _chewieController),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
        onTap: () {},
      ),
    );
  }
}
