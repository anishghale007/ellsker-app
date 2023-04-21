part of 'user_list_cubit.dart';

abstract class UserListState extends Equatable {
  const UserListState();
}

class UserListInitial extends UserListState {
  @override
  List<Object> get props => [];
}

class UserListLoaded extends UserListState {
  final List<UserEntity> users;

  const UserListLoaded({required this.users});
  @override
  List<Object> get props => [users];
}

class UserListFailure extends UserListState {
  final String errorMessage;

  const UserListFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class UserListLoading extends UserListState {
  @override
  List<Object> get props => [];
}
