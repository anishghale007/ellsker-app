import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/sender_user_message_box.dart';
import 'package:intl/intl.dart';

class VoiceMessageWidget extends StatelessWidget {
  final String audioUrl;

  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String messageTime;
  final VoidCallback onSenderLongPress;

  const VoiceMessageWidget({
    super.key,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.audioUrl,
    required this.messageTime,
    required this.onSenderLongPress,
  });

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
    bool isPlaying = false;
    Duration senderDuration = Duration.zero;
    Duration senderPosition = Duration.zero;

    final AudioPlayer audioPlayer = AudioPlayer();

    return FirebaseAuth.instance.currentUser!.uid == senderId
        ? StatefulBuilder(
            builder: (context, setState) {
              return SenderUserMessageBox(
                message: GestureDetector(
                  onLongPress: onSenderLongPress,
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
                                  setState(() {
                                    isPlaying = false;
                                  });
                                } else {
                                  await audioPlayer.play(UrlSource(audioUrl));
                                  setState(() {
                                    isPlaying = true;
                                  });
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
                                max: senderDuration.inSeconds.toDouble(),
                                inactiveColor: Colors.grey,
                                value: senderPosition.inSeconds.toDouble(),
                                onChanged: (value) async {
                                  final position =
                                      Duration(seconds: value.toInt());
                                  await audioPlayer.seek(position);
                                },
                              ),
                            ),
                            Text(
                              formatTime(senderDuration - senderPosition),
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
                            DateTime.parse(messageTime),
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
              );
            },
          )
        : Container();
  }
}
