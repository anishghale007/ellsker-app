import 'package:flutter/material.dart';

class SenderUserMessageBox extends StatelessWidget {
  final Widget message;

  const SenderUserMessageBox({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        message,
      ],
    );
  }
}
