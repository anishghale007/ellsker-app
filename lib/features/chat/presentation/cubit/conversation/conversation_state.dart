
part of 'conversation_cubit.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationSuccess extends ConversationState {}

class ConversationError extends ConversationState {
  final String errorMessage;

  const ConversationError({required this.errorMessage});
}
