part of 'call_bloc.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object> get props => [];
}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallSuccess extends CallState {
  final VideoCallEntity videoCallEntity;

  const CallSuccess({required this.videoCallEntity});

  @override
  List<Object> get props => [videoCallEntity];
}

class CallError extends CallState {
  final String errorMessage;

  const CallError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
