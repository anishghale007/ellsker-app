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

  static Future<void> showImageDialog({
    required BuildContext context,
    required Widget title,
    required bool canPickVideo,
    required VoidCallback onGalleryImageAction,
    required VoidCallback onGalleryVideoAction,
    required VoidCallback onCameraAction,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: title,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          children: [
            InkWell(
              onTap: onGalleryImageAction,
              child: const Chip(
                label: Text("Image"),
                avatar: Icon(Icons.photo_album),
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
            canPickVideo == true
                ? InkWell(
                    onTap: onGalleryVideoAction,
                    child: const Chip(
                      label: Text("Video"),
                      avatar: Icon(Icons.video_call),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                  )
                : Container(),
            InkWell(
              onTap: onCameraAction,
              child: const Chip(
                label: Text("Camera"),
                avatar: Icon(Icons.camera_alt_outlined),
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSimpleDialog({
    required BuildContext context,
    required Widget title,
    required bool canCopy,
    required bool canUnsend,
    required VoidCallback onCopy,
    required VoidCallback onUnsend,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: title,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          children: [
            canCopy == true
                ? ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0.0),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey.withOpacity(0.8);
                          }
                          return Colors.white;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    onPressed: onCopy,
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Copy",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(),
            canUnsend == true
                ? ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0.0),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey.withOpacity(0.8);
                          }
                          return Colors.white;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    onPressed: onUnsend,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                    label: const Text(
                      "Unsend",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
