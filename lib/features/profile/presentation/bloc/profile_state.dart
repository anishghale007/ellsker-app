part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Stream<UserProfileEntity> userProfileEntity;

  const ProfileLoaded({required this.userProfileEntity});

  @override
  List<Object> get props => [userProfileEntity];
}

class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ProfileEditSuccess extends ProfileState {}
