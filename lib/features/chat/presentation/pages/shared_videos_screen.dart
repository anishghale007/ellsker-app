import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/common/widgets/loading_widget.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/widgets/shared_videos_widget.dart';

class SharedVideosScreen extends StatelessWidget {
  final String receiverId;

  const SharedVideosScreen({
    super.key,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<MessageCubit, MessageState>(
              bloc: context.read<MessageCubit>()
                ..getAllSharedVideos(receiverId: receiverId),
              builder: (context, state) {
                if (state is SharedVideosLoaded) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: state.videoList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2.5,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final data = state.videoList[index];
                      return SharedVideosWidget(
                        videoUrl: data,
                      );
                    },
                  );
                } else if (state is MessageLoading) {
                  return const LoadingWidget(
                    color: Colors.blueAccent,
                  );
                } else if (state is MessageError) {
                  return Center(
                    child: Text(state.errorMessage.toString()),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
