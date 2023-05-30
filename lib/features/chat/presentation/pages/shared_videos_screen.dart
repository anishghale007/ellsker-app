import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';

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
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                        ),
                        child: Text(
                          data.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        // CachedNetworkImage(
                        //   imageUrl: data,
                        //   fit: BoxFit.contain,
                        //   errorWidget: (context, url, error) =>
                        //       const Icon(Icons.error),
                        // ),
                      );
                    },
                  );
                } else if (state is MessageLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
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
