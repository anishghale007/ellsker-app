import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class ReceiverUserMessageBox extends StatelessWidget {
  final String senderPhotoUrl;
  final String senderName;
  final Widget message;

  const ReceiverUserMessageBox({
    super.key,
    required this.senderPhotoUrl,
    required this.senderName,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CachedNetworkImage(
          imageUrl: senderPhotoUrl,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            foregroundImage: imageProvider,
            radius: 15,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                senderName,
                style: GoogleFonts.sourceSansPro(
                  color: ColorUtil.kTertiaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              message,
            ],
          ),
        ),
      ],
    );
  }
}
