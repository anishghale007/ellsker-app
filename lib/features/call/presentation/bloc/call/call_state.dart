part of 'call_bloc.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object> get props => [];
}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallError extends CallState {
  final String errorMessage;

  const CallError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CallSuccess extends CallState {}
