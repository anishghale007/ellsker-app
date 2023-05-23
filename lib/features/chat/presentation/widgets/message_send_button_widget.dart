import 'package:flutter/material.dart';

class MessageSendButtonWidget extends StatelessWidget {
  final VoidCallback onPress;
  final IconData buttonIcon;

  const MessageSendButtonWidget({
    super.key,
    required this.onPress,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffE45699),
            Color(0xff733DD6),
            Color(0xff3D88E4),
          ],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.only(right: 0),
        ),
        child: Icon(
          buttonIcon,
          color: Colors.white,
        ),
      ),
    );
  }
}
