part of 'facebook_sign_in_bloc.dart';

abstract class FacebookSignInState extends Equatable {
  const FacebookSignInState();

  @override
  List<Object> get props => [];
}

class FacebookSignInInitial extends FacebookSignInState {}

class FacebookSignInLoading extends FacebookSignInState {}

class FacebookSignInSuccess extends FacebookSignInState {
  final FacebookUserEntity facebookUserEntity;

  const FacebookSignInSuccess({required this.facebookUserEntity});

  @override
  List<Object> get props => [facebookUserEntity];
}

class FacebookSignInFailure extends FacebookSignInState {
  final String errorMessage;

  const FacebookSignInFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
