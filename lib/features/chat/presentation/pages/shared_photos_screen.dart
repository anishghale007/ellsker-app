import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';

import '../../../../injection_container.dart';

class SharedPhotosScreen extends StatefulWidget {
  final String receiverId;

  const SharedPhotosScreen({
    super.key,
    required this.receiverId,
  });

  @override
  State<SharedPhotosScreen> createState() => _SharedPhotosScreenState();
}

class _SharedPhotosScreenState extends State<SharedPhotosScreen> {
  late MessageCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<MessageCubit>()
      ..getAllSharedPhotos(receiverId: widget.receiverId);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => _bloc,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<MessageCubit, MessageState>(
                builder: (context, state) {
                  if (state is MessagePhotos) {
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: state.photoList.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2.5,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final data = state.photoList[index];
                        return FullScreenWidget(
                          disposeLevel: DisposeLevel.Low,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: CachedNetworkImage(
                              imageUrl: data,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
