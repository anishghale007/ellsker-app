import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';

class ChangeProfilePictureWidget extends StatelessWidget {
  final VoidCallback onPress;
  final ImageProvider<Object>? backgroundImage;

  const ChangeProfilePictureWidget({
    super.key,
    required this.onPress,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xff666A83),
            width: 4,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: backgroundImage,
          radius: 80,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: onPress,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorUtil.kMessageAlertColor,
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
