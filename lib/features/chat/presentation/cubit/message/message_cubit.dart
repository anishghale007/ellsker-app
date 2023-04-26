import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_messages_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/send_message_usecase.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetAllMessagesUsecase getAllMessagesUsecase;

  MessageCubit({
    required this.sendMessageUseCase,
    required this.getAllMessagesUsecase,
  }) : super(MessageInitial());

  Future<void> sendMessage({required MessageEntity messageEntity}) async {
    try {
      emit(MessageLoading());
      final response =
          await sendMessageUseCase.call(Params(messageEntity: messageEntity));
      response.fold(
          (failure) => emit(MessageError(errorMessage: failure.toString())),
          (success) => emit(MessageSuccess()));
    } catch (e) {
      emit(MessageError(errorMessage: e.toString()));
    }
  }

  Future<void> getAllMessages({required String conversationId}) async {
    try {
      emit(MessageLoading());
      final response = await getAllMessagesUsecase
          .call(Param(conversationId: conversationId));
      response.fold(
        (failure) => emit(MessageError(errorMessage: failure.toString())),
        (messages) => messages.listen(
          (message) {
            emit(MessageLoaded(messageList: message));
          },
        ),
      );
    } catch (e) {
      emit(MessageError(errorMessage: e.toString()));
    }
  }
}
