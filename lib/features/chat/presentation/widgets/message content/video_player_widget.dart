import 'package:cached_video_player/cached_video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/receiver_user_message_box.dart';
import 'package:intl/intl.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String videoUrl;
  final String messageTime;
  final VoidCallback onSenderLongPress;

  const VideoPlayerWidget({
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.videoUrl,
    required this.messageTime,
    required this.onSenderLongPress,
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == widget.senderId
        ? GestureDetector(
            onLongPress: widget.onSenderLongPress,
            child: Container(
              margin: const EdgeInsets.only(
                left: 40,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff6E56FF),
                    Color(0xff4329E5),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AspectRatio(
                    aspectRatio: 12 / 10,
                    child: Stack(
                      children: [
                        CachedVideoPlayer(videoPlayerController),
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              if (isPlay) {
                                videoPlayerController.pause();
                              } else {
                                videoPlayerController.play();
                              }

                              setState(() {
                                isPlay = !isPlay;
                              });
                            },
                            icon: Icon(
                              isPlay ? Icons.pause_circle : Icons.play_circle,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    DateFormat('Hm').format(
                      DateTime.parse(widget.messageTime),
                    ),
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        : ReceiverUserMessageBox(
            senderPhotoUrl: widget.senderPhotoUrl,
            senderName: widget.senderName,
            message: Container(
              margin: const EdgeInsets.only(
                right: 40,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: ColorUtil.kPrimaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 12 / 10,
                    child: Stack(
                      children: [
                        CachedVideoPlayer(videoPlayerController),
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              if (isPlay) {
                                videoPlayerController.pause();
                              } else {
                                videoPlayerController.play();
                              }

                              setState(() {
                                isPlay = !isPlay;
                              });
                            },
                            icon: Icon(
                              isPlay ? Icons.pause_circle : Icons.play_circle,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    DateFormat('Hm').format(
                      DateTime.parse(widget.messageTime),
                    ),
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
