import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListTileWidget extends StatelessWidget {
  const ShimmerListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 27,
          ),
          title: Container(
            height: 15,
            color: Colors.grey,
          ),
          subtitle: Container(
            height: 12,
            color: Colors.grey,
            margin: const EdgeInsets.only(right: 180),
          ),
        ),
      ),
    );
  }
}
