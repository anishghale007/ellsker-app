import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String profilePictureUrl;

  const ProfilePictureWidget({
    super.key,
    required this.profilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 350,
      foregroundDecoration: BoxDecoration(
        color: Colors.green,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [
            0,
            0.2,
            0.6,
            1,
          ],
          colors: [
            ColorUtil.kPrimaryColor,
            Colors.transparent,
            Colors.transparent,
            ColorUtil.kPrimaryColor,
          ],
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: profilePictureUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
                value: progress.progress, backgroundColor: Colors.white),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
