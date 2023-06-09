import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

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
        appId: 'be4b0f54027345278394c4681a45a768',
        channelName: 'test',
        // tempToken: widget.rtcToken,
        // tokenUrl: Constant.tokenBaseUrl,
        // tokenUrl: "https://ellsker-token-generator.onrender.com",
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
                    layoutType: Layout.floating,
                    showNumberOfUsers: true,
                  ),
                  AgoraVideoButtons(
                    client: _agoraClient!,
                    enabledButtons: const [
                      BuiltInButtons.toggleCamera,
                      BuiltInButtons.callEnd,
                      BuiltInButtons.toggleMic,
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
