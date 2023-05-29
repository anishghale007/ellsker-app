import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SharedVideosScreen extends StatelessWidget {
  const SharedVideosScreen({super.key});

  Future<void> storageFiles() async {
    List<String> photoList = [];
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("smgvhiMr7ZX7ylD3Ie6RqIrRPkD3-gsbLwpdiSLUV0pCqLOe2EUvJbCs1/");
    final listResult = await storageRef.listAll();
    for (Reference ref in listResult.items) {
      final fileUrl = await ref.getDownloadURL();
      photoList.add(fileUrl);
      String finalStr = photoList.reduce((value, element) {
        return "$value, $element";
      });
      log("List: $finalStr");

      // log("FileURL: $fileUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                storageFiles();
              },
              child: const Text("FILE URL"),
            ),
          ],
        ),
      ),
    );
  }
}
