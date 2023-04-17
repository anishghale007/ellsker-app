part of 'user_list_bloc.dart';

abstract class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<UserEntity> userList;

  const UserListLoaded({required this.userList});

  @override
  List<Object> get props => [userList];
}

class UserListError extends UserListState {
  final String errorMessage;

  const UserListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
