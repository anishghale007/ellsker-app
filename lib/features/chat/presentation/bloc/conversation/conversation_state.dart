part of 'conversation_bloc.dart';

abstract class ConversationsState extends Equatable {
  const ConversationsState();

  @override
  List<Object> get props => [];
}

class ConversationsInitial extends ConversationsState {}

class ConversationsEmpty extends ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsCreated extends ConversationsState {}

class ConversationsDeleted extends ConversationsState {}

class ConversationsSeen extends ConversationsState {}

class ConversationsError extends ConversationsState {
  final String errorMessage;

  const ConversationsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
