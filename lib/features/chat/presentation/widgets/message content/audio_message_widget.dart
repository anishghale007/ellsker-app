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
  bool isReceiverPlaying = false;
  bool isSenderPlaying = false;
  Duration receiverDuration = Duration.zero;
  Duration receiverPosition = Duration.zero;
  Duration senderDuration = Duration.zero;
  Duration senderPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    // Listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isReceiverPlaying = state == PlayerState.playing;
        isSenderPlaying = state == PlayerState.playing;
      });
    });
    // Listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        receiverDuration = newDuration;
        senderDuration = newDuration;
      });
    });
    // Listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        receiverPosition = newPosition;
        senderPosition = newPosition;
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
                            if (isSenderPlaying) {
                              await audioPlayer.pause();
                            } else {
                              startAudio();
                              await audioPlayer
                                  .setReleaseMode(ReleaseMode.loop);
                              await audioPlayer.resume();
                            }
                          },
                          icon: isSenderPlaying
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
                            max: senderDuration.inSeconds.toDouble(),
                            inactiveColor: Colors.grey,
                            value: senderPosition.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await audioPlayer.seek(position);
                            },
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
                right: 50,
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
                          if (isReceiverPlaying) {
                            await audioPlayer.pause();
                          } else {
                            startAudio();
                            await audioPlayer.setReleaseMode(ReleaseMode.loop);
                            await audioPlayer.resume();
                          }
                        },
                        icon: isReceiverPlaying
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
                          max: receiverDuration.inSeconds.toDouble(),
                          inactiveColor: Colors.grey,
                          value: receiverPosition.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                          },
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
