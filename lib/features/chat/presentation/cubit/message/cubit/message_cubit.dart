import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/send_message_usecase.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final SendMessageUseCase sendMessageUseCase;

  MessageCubit({
    required this.sendMessageUseCase,
  }) : super(MessageInitial());

  Future<void> sendMessage({required MessageEntity messageEntity}) async {
    try {
      await sendMessageUseCase.call(messageEntity);
      emit(MessageSuccess());
    } catch (e) {
      emit(MessageError(errorMessage: e.toString()));
    }
  }
}
