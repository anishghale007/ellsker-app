part of 'conversation_cubit.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationEmpty extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<ConversationEntity> conversationList;

  const ConversationLoaded({required this.conversationList});

  @override
  List<Object> get props => [conversationList];
}

class ConversationSuccess extends ConversationState {}

class ConversationError extends ConversationState {
  final String errorMessage;

  const ConversationError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
