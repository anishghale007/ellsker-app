import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/delete_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/seen_message_usecase.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationsState> {
  final CreateConversationUseCase createConversationUseCase;
  final SeenMessageUsecase seenMessageUsecase;
  final DeleteConversationUseCase deleteConversationUseCase;

  ConversationBloc({
    required this.createConversationUseCase,
    required this.seenMessageUsecase,
    required this.deleteConversationUseCase,
  }) : super(ConversationsInitial()) {
    on<CreateConversationEvent>(_onCreateConversation);
    on<SeenConversationEvent>(_seenMessage);
    on<DeleteConversationEvent>(_onDeleteConversation);
  }

  Future<void> _onCreateConversation(
      CreateConversationEvent event, Emitter<ConversationsState> emit) async {
    final createConversation = await createConversationUseCase.call(
      CreateConversationParams(conversationEntity: event.conversationEntity),
    );
    emit(ConversationsLoading());
    createConversation.fold(
      (failure) => emit(
        ConversationsError(errorMessage: failure.toString()),
      ),
      (createConversation) => emit(ConversationsCreated()),
    );
  }

  Future<void> _onDeleteConversation(
      DeleteConversationEvent event, Emitter<ConversationsState> emit) async {
    try {
      final deleteConversation = await deleteConversationUseCase
          .call(DeleteConversationParams(conversationId: event.conversationId));
      emit(ConversationsLoading());
      deleteConversation.fold(
          (failure) => ConversationsError(errorMessage: failure.toString()),
          (success) => emit(ConversationsDeleted()));
    } catch (e) {
      emit(ConversationsError(errorMessage: e.toString()));
    }
  }

  Future<void> _seenMessage(
      SeenConversationEvent event, Emitter<ConversationsState> emit) async {
    try {
      final seenMessage = await seenMessageUsecase
          .call(SeenMessageParams(conversationId: event.conversationId));
      emit(ConversationsLoading());
      seenMessage.fold(
          (failure) => emit(
                ConversationsError(errorMessage: failure.toString()),
              ),
          (seenMessage) => emit(ConversationsSeen()));
    } catch (e) {
      emit(ConversationsError(errorMessage: e.toString()));
    }
  }
}
