import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/call/domain/entities/call_entity.dart';
import 'package:intl/intl.dart';

class CallLogListTileWidget extends StatelessWidget {
  final CallEntity data;
  final String currentUser;
  final int callTime;

  const CallLogListTileWidget({
    super.key,
    required this.data,
    required this.currentUser,
    required this.callTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: data.callerPhotoUrl,
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.white,
        ),
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
          value: progress.progress,
          backgroundColor: Colors.white,
        ),
        imageBuilder: (context, imageProvider) => CircleAvatar(
          foregroundImage: imageProvider,
          radius: 27,
        ),
      ),
      title: Text(
        currentUser == data.callerId ? "You" : data.callerName,
        style: GoogleFonts.sourceSansPro(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.phone_callback,
            color: ColorUtil.kTertiaryColor,
            size: 15,
          ),
          Text(
            "  $callTime mins  ",
            style: GoogleFonts.sourceSansPro(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            DateFormat('(HH:mm * d MMMM)').format(
              DateTime.parse(data.callStartTime),
            ),
            style: GoogleFonts.sourceSansPro(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: currentUser == data.callerId
          ? null
          : ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.grey[700],
              ),
              child: const Icon(
                Icons.call,
                size: 20,
              ),
            ),
    );
  }
}
