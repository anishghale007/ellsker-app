part of 'user_status_cubit.dart';

abstract class UserStatusState extends Equatable {
  const UserStatusState();

  @override
  List<Object> get props => [];
}

class UserStatusInitial extends UserStatusState {}

class UserStatusSuccess extends UserStatusState {}

class UserStatusError extends UserStatusState {
  final String errorMessage;

  const UserStatusError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
