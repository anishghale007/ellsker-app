part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class GetAllMessage extends MessageEvent {
  @override
  List<Object> get props => [];
}
