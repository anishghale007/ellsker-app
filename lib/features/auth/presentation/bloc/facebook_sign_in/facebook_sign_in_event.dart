
part of 'facebook_sign_in_bloc.dart';

abstract class FacebookSignInEvent extends Equatable {
  const FacebookSignInEvent();

  @override
  List<Object> get props => [];
}

class FacebookUserEvent extends FacebookSignInEvent {
  @override
  List<Object> get props => [];
}
