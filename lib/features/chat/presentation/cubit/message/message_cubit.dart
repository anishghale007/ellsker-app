import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_chat_message.dart';
import 'package:internship_practice/features/chat/domain/usecases/send_message_usecase.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final SendMessageUseCase sendTextMessageUseCase;
  final GetAllChatMessagesUseCase getAllChatMessagesUseCase;

  MessageCubit({
    required this.sendTextMessageUseCase,
    required this.getAllChatMessagesUseCase,
  }) : super(MessageInitial());

  // static MessageCubit get(context) => BlocProvider.of(context);

  Future<void> sendTextMessage({required MessageEntity messageEntity}) async {
    try {
      emit(MessageLoading());
      final response = await sendTextMessageUseCase
          .call(SendMessageParams(messageEntity: messageEntity));
      response.fold(
          (failure) => emit(MessageError(errorMessage: failure.toString())),
          (success) => emit(MessageSuccess()));
    } catch (e) {
      emit(MessageError(errorMessage: e.toString()));
    }
  }

  Stream<List<MessageEntity>> getAllChatMessages(
      {required String conversationId}) {
    return getAllChatMessagesUseCase
        .call(GetAllChatMessagesParams(conversationId: conversationId));
  }
}
