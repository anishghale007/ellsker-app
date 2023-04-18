import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final CreateConversationUseCase createConversationUseCase;

  ConversationCubit({
    required this.createConversationUseCase,
  }) : super(ConversationInitial());

  Future<void> createConversation(
      {required ConversationEntity conversationEntity}) async {
    try {
      await createConversationUseCase.call(conversationEntity);
      emit(ConversationSuccess());
    } catch (e) {
      emit(ConversationError(errorMessage: e.toString()));
    }
  }
}
