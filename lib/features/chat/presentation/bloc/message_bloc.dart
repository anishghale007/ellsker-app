import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_messages_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetAllMessagesUsecase getAllMessagesUsecase;

  MessageBloc({
    required this.getAllMessagesUsecase,
  }) : super(MessageInitial()) {
    on<MessageEvent>((event, emit) {
      on<GetAllMessage>(_onGetAllMessage);
    });
  }

  void _onGetAllMessage(GetAllMessage event, Emitter<MessageState> emit) async {
    // await getAllMessagesUsecase.call();
  }
}
