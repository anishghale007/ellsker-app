part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUserEvent extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {
  final UserProfileEntity userProfileEntity;

  const EditProfileEvent({required this.userProfileEntity});

  @override
  List<Object> get props => [userProfileEntity];
}
