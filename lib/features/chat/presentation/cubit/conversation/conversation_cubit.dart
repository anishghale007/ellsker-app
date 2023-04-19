import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_conversation_usecase.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final CreateConversationUseCase createConversationUseCase;
  final GetAllConversationUsecase getAllConversationUsecase;

  ConversationCubit({
    required this.createConversationUseCase,
    required this.getAllConversationUsecase,
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

  Future<void> getAllConversations() async {
    emit(ConversationLoading());
    final response = getAllConversationUsecase.call();
    response.listen((conversations) {
      emit(ConversationLoaded(conversationList: conversations));
    });
  }
}
