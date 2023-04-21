import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation_usecase.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final CreateConversationUseCase createConversationUseCase;

  ConversationBloc({
    required this.createConversationUseCase,
  }) : super(ConversationInitial()) {
    on<CreateConversationEvent>(_onCreateConversation);
  }

  Future<void> _onCreateConversation(
      CreateConversationEvent event, Emitter<ConversationState> emit) async {
    final createConversation = await createConversationUseCase.call(
      Params(conversationEntity: event.conversationEntity),
    );
    emit(ConversationLoading());
    createConversation.fold(
      (failure) => emit(
        ConversationError(errorMessage: failure.toString()),
      ),
      (createConversation) => emit(ConversationCreated()),
    );
  }
}
