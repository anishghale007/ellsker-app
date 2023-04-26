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

class SeenConversationEvent extends ConversationEvent {
  final String conversationId;

  const SeenConversationEvent({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}
