part of 'token_bloc.dart';

abstract class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object> get props => [];
}

class CallInitial extends TokenState {}

class CallLoading extends TokenState {}

class CallSuccess extends TokenState {
  final RtcTokenEntity videoCallEntity;

  const CallSuccess({required this.videoCallEntity});

  @override
  List<Object> get props => [videoCallEntity];
}

class CallError extends TokenState {
  final String errorMessage;

  const CallError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
