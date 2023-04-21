part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class CreateConversationEvent extends ConversationEvent {
  final ConversationEntity conversationEntity;

  const CreateConversationEvent({required this.conversationEntity});

  @override
  List<Object> get props => [conversationEntity];
}
