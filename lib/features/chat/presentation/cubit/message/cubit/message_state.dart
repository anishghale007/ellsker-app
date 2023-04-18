part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageSuccess extends MessageState {}

class MessageError extends MessageState {
  final String errorMessage;

  const MessageError({required this.errorMessage});
}
