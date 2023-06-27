import 'dart:developer';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/config/agora_config.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';

class VideoCallScreen extends StatefulWidget {
  final String callerId;
  final String callerPhotoUrl;
  final String callerName;
  final String receiverId;
  final String callStartTime;

  const VideoCallScreen({
    required this.callerId,
    required this.callerPhotoUrl,
    required this.callerName,
    required this.receiverId,
    required this.callStartTime,
    super.key,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  AgoraClient? _agoraClient;

  @override
  void initState() {
    super.initState();
    _agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        // appId: Constant.appId,
        appId: AgoraConfig.appId,
        channelName: 'test',
        tokenUrl: Constant.tokenBaseUrl,
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
      agoraEventHandlers: AgoraRtcEventHandlers(
        onLeaveChannel: (connection, stats) async {
          context.router.popForced();
          log("User left the channel");
          await _agoraClient!.engine.leaveChannel();
        },
      ),
    );
    initAgora();
  }

  // @override
  // void dispose() {
  //   _agoraClient!.release();
  //   super.dispose();
  // }

  void initAgora() async {
    await _agoraClient!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _agoraClient == null
          ? Container()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(
                    client: _agoraClient!,
                  ),
                  AgoraVideoButtons(
                    client: _agoraClient!,
                    enabledButtons: const [
                      BuiltInButtons.callEnd,
                      BuiltInButtons.toggleMic,
                      BuiltInButtons.toggleCamera,
                      BuiltInButtons.switchCamera,
                    ],
                    disconnectButtonChild: ElevatedButton(
                      onPressed: () async {
                        await _agoraClient!.engine.leaveChannel();
                        // Go back to the chat screen
                        context.router.popForced();
                        // End Call Event
                        if (mounted) {
                          context.read<CallBloc>().add(
                                EndCallEvent(
                                  callerId: widget.callerId,
                                  callerPhotoUrl: widget.callerPhotoUrl,
                                  callerName: widget.callerName,
                                  receiverId: widget.receiverId,
                                  callStartTime:
                                      widget.callStartTime, // from other screen
                                  callEndTime: DateTime.now().toString(),
                                  didPickup: true,
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.red,
                      ),
                      child: const Icon(
                        Icons.call_end,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
