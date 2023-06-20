import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SharedVideosWidget extends StatefulWidget {
  final String videoUrl;

  const SharedVideosWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<SharedVideosWidget> createState() => _SharedVideosWidgetState();
}

class _SharedVideosWidgetState extends State<SharedVideosWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      // zoomAndPan: false,
      // allowFullScreen: true,
      // showControls: true,
      // showOptions: false,
      fullScreenByDefault: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Chewie(
        controller: chewieController,
      ),
    );
  }
}
