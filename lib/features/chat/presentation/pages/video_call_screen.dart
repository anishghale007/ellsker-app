import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraClient _agoraClient = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'be4b0f54027345278394c4681a45a768',
      channelName: 'ellsker-app',
      tempToken:
          '007eJxTYCid6sHnavBxTbpDWNTRFbMml+Q9WlN2xt2dY8tmq4Ytp7kVGJJSTZIM0kxNDIzMjU1MjcwtjC1Nkk3MLAwTTUwTzc0sduhmpzQEMjIcrGFiYWSAQBCfmyE1J6c4O7VIN7GggIEBANsMIHk=',
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await _agoraClient.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: _agoraClient,
              layoutType: Layout.floating,
              showNumberOfUsers: true,
            ),
            AgoraVideoButtons(
              client: _agoraClient,
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
