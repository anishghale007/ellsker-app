import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/pages/shared_photos_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/shared_videos_screen.dart';
import 'package:internship_practice/injection_container.dart';

class SharedFilesScreen extends StatefulWidget implements AutoRouteWrapper {
  final String receiverId;

  const SharedFilesScreen({
    super.key,
    required this.receiverId,
  });

  @override
  State<SharedFilesScreen> createState() => _SharedFilesScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MessageCubit>(),
      // ..getAllSharedPhotos(receiverId: receiverId)
      // ..getAllSharedVideos(receiverId: receiverId),
      child: this,
    );
  }
}

class _SharedFilesScreenState extends State<SharedFilesScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                // onTap: (value) {
                //   switch (value) {
                //     case 0:
                //       context
                //           .read<MessageCubit>()
                //           .getAllSharedPhotos(receiverId: widget.receiverId);
                //       break;
                //     case 1:
                //       context
                //           .read<MessageCubit>()
                //           .getAllSharedVideos(receiverId: widget.receiverId);
                //       break;
                //     default:
                //   }
                // },
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
            SharedVideosScreen(
              receiverId: widget.receiverId,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
