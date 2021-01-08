import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wokubot/utils/video_controls_overlay.dart';

class MediaPlayer extends StatefulWidget {
  final File file;
  final String placeholderAsset;
  final double aspectRatio;

  const MediaPlayer({Key key, this.file, this.placeholderAsset, this.aspectRatio}) : super(key: key);
  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  VideoPlayerController controller;

  void _initVideoPlayer() {
    controller = VideoPlayerController.file(widget.file)
      ..addListener(() => setState(() {}))
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (controller.value.initialized)
        ? AspectRatio(
            aspectRatio: widget.aspectRatio ?? controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(color: Colors.black87),
                VideoPlayer(controller),
                VideoControlsOverlay(controller: controller),
                VideoProgressIndicator(controller, allowScrubbing: true),
              ],
            ),
          )
        : Image.asset(widget.placeholderAsset);
  }
}
