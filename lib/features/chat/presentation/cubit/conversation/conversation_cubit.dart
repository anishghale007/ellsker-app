import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/seen_message_usecase.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final CreateConversationUseCase createConversationUseCase;
  final GetAllConversationUsecase getAllConversationUsecase;
  final SeenMessageUsecase seenMessageUsecase;

  ConversationCubit({
    required this.createConversationUseCase,
    required this.getAllConversationUsecase,
    required this.seenMessageUsecase,
  }) : super(ConversationInitial());

  Future<void> createConversation(
      {required ConversationEntity conversationEntity}) async {
    try {
      final response = await createConversationUseCase.call(
          CreateConversationParams(conversationEntity: conversationEntity));
      response.fold(
          (failure) =>
              emit(ConversationError(errorMessage: failure.toString())),
          (success) => emit(ConversationSuccess()));
    } catch (e) {
      emit(ConversationError(errorMessage: e.toString()));
    }
  }

  Stream<List<ConversationEntity>> getAllConversations() {
    return getAllConversationUsecase.call(NoParams());
  }

  // Future<void> getAllConversations() async {
  //   emit(ConversationLoading());
  //   final response = await getAllConversationUsecase.call(NoParams());
  //   response.fold(
  //     (failure) => emit(ConversationError(errorMessage: failure.toString())),
  //     (conversationList) => conversationList.listen((conversation) {
  //       emit(ConversationLoaded(conversationList: conversation));
  //     }),
  //   );
  // }

  Future<void> seenMessage({required String conversationId}) async {
    try {
      final response = await seenMessageUsecase
          .call(SeenMessageParams(conversationId: conversationId));
      response.fold(
          (failure) =>
              emit(ConversationError(errorMessage: failure.toString())),
          (success) => emit(ConversationSuccess()));
    } catch (e) {
      emit(ConversationError(errorMessage: e.toString()));
    }
  }
}
