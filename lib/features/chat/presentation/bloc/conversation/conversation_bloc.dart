import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/seen_message_usecase.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationsState> {
  final CreateConversationUseCase createConversationUseCase;
  final SeenMessageUsecase seenMessageUsecase;

  ConversationBloc({
    required this.createConversationUseCase,
    required this.seenMessageUsecase,
  }) : super(ConversationsInitial()) {
    on<CreateConversationEvent>(_onCreateConversation);
    on<SeenConversationEvent>(_seenMessage);
  }

  Future<void> _onCreateConversation(
      CreateConversationEvent event, Emitter<ConversationsState> emit) async {
    final createConversation = await createConversationUseCase.call(
      Params(conversationEntity: event.conversationEntity),
    );
    emit(ConversationsLoading());
    createConversation.fold(
      (failure) => emit(
        ConversationsError(errorMessage: failure.toString()),
      ),
      (createConversation) => emit(ConversationsCreated()),
    );
  }

  Future<void> _seenMessage(
      SeenConversationEvent event, Emitter<ConversationsState> emit) async {
    try {
      final seenMessage = await seenMessageUsecase
          .call(Param(conversationId: event.conversationId));
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
