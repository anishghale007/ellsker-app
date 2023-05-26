import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/receiver_user_message_box.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/sender_user_message_box.dart';
import 'package:intl/intl.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String messageTime;
  final VoidCallback onSenderLongPress;

  const AudioMessageWidget({
    super.key,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.audioUrl,
    required this.messageTime,
    required this.onSenderLongPress,
  });

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    // Listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    // Listen to audio duration
    startAudio();
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
        pauseAudio();
      });
    });
    // Listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void startAudio() {
    audioPlayer.play(
      UrlSource(widget.audioUrl),
      volume: 5.0,
    );
  }

  Future pauseAudio() async {
    await audioPlayer.pause();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == widget.senderId
        ? SenderUserMessageBox(
            message: GestureDetector(
              onLongPress: widget.onSenderLongPress,
              child: Container(
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (isPlaying) {
                              await audioPlayer.pause();
                            } else {
                              startAudio();
                              await audioPlayer
                                  .setReleaseMode(ReleaseMode.loop);
                              await audioPlayer.resume();
                            }
                          },
                          icon: isPlaying
                              ? const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbColor: Colors.transparent,
                            thumbShape: const RoundSliderOverlayShape(
                              overlayRadius: 0.0,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            inactiveColor: Colors.grey,
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await audioPlayer.seek(position);
                            },
                          ),
                        ),
                        Text(
                          formatTime(duration - position),
                          style: GoogleFonts.sourceSansPro(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
            ),
          )
        : ReceiverUserMessageBox(
            senderName: widget.senderName,
            senderPhotoUrl: widget.senderPhotoUrl,
            message: Container(
              margin: const EdgeInsets.only(
                right: 20,
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            startAudio();
                            await audioPlayer.setReleaseMode(ReleaseMode.loop);
                            await audioPlayer.resume();
                          }
                        },
                        icon: isPlaying
                            ? const Icon(
                                Icons.pause,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                              ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Colors.transparent,
                          thumbShape: const RoundSliderOverlayShape(
                            overlayRadius: 0.0,
                          ),
                        ),
                        child: Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          inactiveColor: Colors.grey,
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                          },
                        ),
                      ),
                      Text(
                        formatTime(duration - position),
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
