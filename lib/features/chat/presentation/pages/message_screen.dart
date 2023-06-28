import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final String remoteMessage;

  const MessageScreen({
    super.key,
    required this.remoteMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messsage Screen"),
      ),
      body: Column(
        children: [
          Text(
            remoteMessage,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
