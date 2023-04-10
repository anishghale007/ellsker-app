part of 'google_sign_in_bloc.dart';

abstract class GoogleSignInState extends Equatable {
  const GoogleSignInState();

  @override
  List<Object> get props => [];
}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {
  final GoogleUserEntity googleUserEntity;

  const GoogleSignInSuccess({required this.googleUserEntity});

  @override
  List<Object> get props => [googleUserEntity];
}

class GoogleSignInFailure extends GoogleSignInState {
  final String errorMessage;

  const GoogleSignInFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
