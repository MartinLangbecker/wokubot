import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaPlayer extends StatefulWidget {
  final File file;
  final String placeholderAsset;
  final double? aspectRatio;

  const MediaPlayer({Key? key, required this.file, required this.placeholderAsset, this.aspectRatio}) : super(key: key);
  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  Future<void> initializePlayer() async {
    _videoController = VideoPlayerController.file(widget.file);
    await _videoController.initialize();
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoInitialize: true,
      aspectRatio: widget.aspectRatio,
      allowFullScreen: false,
      allowPlaybackSpeedChanging: false,
    );
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized)
        // ? Chewie(controller: _chewieController!)
        ? AspectRatio(
            aspectRatio: widget.aspectRatio ?? _chewieController!.videoPlayerController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Chewie(controller: _chewieController!),
              ],
            ),
          )
        : Image.asset(widget.placeholderAsset);
  }
}
