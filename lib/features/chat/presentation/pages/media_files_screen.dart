import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/pages/shared_photos_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/shared_videos_screen.dart';
import 'package:internship_practice/injection_container.dart';

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
  late MessageCubit bloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    bloc = sl<MessageCubit>()
      ..getAllSharedPhotos(receiverId: widget.receiverId)
      ..getAllSharedVideos(receiverId: widget.receiverId);
  }

  @override
  void dispose() {
    bloc.close();
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
                onTap: (value) {
                  switch (value) {
                    case 0:
                      context
                          .read<MessageCubit>()
                          .getAllSharedPhotos(receiverId: widget.receiverId);
                      break;
                    case 1:
                      context
                          .read<MessageCubit>()
                          .getAllSharedVideos(receiverId: widget.receiverId);
                      break;
                    default:
                  }
                },
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
        body: BlocProvider(
          create: (context) => bloc,
          child: TabBarView(
            controller: _tabController,
            children: [
              SharedPhotosScreen(
                receiverId: widget.receiverId,
              ),
              SharedVideosScreen(
                receiverId: widget.receiverId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
