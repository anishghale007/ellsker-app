import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:internship_practice/core/config/agora_config.dart';

class VideoCallScreen extends StatefulWidget {
  // final String rtcToken;

  const VideoCallScreen({
    // required this.rtcToken,
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
        tokenUrl: 'https://ellsker-token-server.onrender.com',
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );
    initAgora();
  }

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

                        // Send the call message

                        // If the user does not pickup send missed call message

                        // send the call data to the call history collection

                        // set the isDialled to false in both of the user collection

                        // set the inCall to false in both of the user collection
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
