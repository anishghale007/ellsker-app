import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internship_practice/features/chat/presentation/pages/shared_photos_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/shared_videos_screen.dart';

class SharedFilesScreen extends StatefulWidget {
  final String receiverId;

  const SharedFilesScreen({
    super.key,
    required this.receiverId,
  });

  @override
  State<SharedFilesScreen> createState() => _SharedFilesScreenState();
}

class _SharedFilesScreenState extends State<SharedFilesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> storageFiles() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("smgvhiMr7ZX7ylD3Ie6RqIrRPkD3-gsbLwpdiSLUV0pCqLOe2EUvJbCs1/");
    final listResult = await storageRef.listAll();
    for (Reference ref in listResult.items) {
      final fileUrl = await ref.getDownloadURL();
      log("FileURL: $fileUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Media and Files",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 60),
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: Colors.grey[600],
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[300],
                ),
                tabs: const [
                  Tab(
                    text: "Photos",
                  ),
                  Tab(
                    text: "Videos",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SharedPhotosScreen(
              receiverId: widget.receiverId,
            ),
            const SharedVideosScreen(),
          ],
        ),
      ),
    );
  }
}
