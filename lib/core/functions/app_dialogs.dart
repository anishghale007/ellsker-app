import 'package:flutter/material.dart';

class AppDialogs {
  static Future<void> showAlertDialog({
    required BuildContext context,
    required Widget title,
    required Widget content,
    required List<Widget>? actions,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: actions,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
