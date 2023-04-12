import 'package:equatable/equatable.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/features/auth/domain/entities/facebook_user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/facebook_login_usecase.dart';
part 'facebook_sign_in_event.dart';
part 'facebook_sign_in_state.dart';

class FacebookSignInBloc
    extends Bloc<FacebookSignInEvent, FacebookSignInState> {
  final FacebookLoginUseCase facebookLoginUseCase;

  FacebookSignInBloc({
    required this.facebookLoginUseCase,
  }) : super(FacebookSignInInitial()) {
    on<FacebookUserEvent>(_facebookSignIn);
  }

  Future<void> _facebookSignIn(
      FacebookUserEvent event, Emitter<FacebookSignInState> emit) async {
    emit(FacebookSignInLoading());
    try {
      final facebookUser = await facebookLoginUseCase.call();
      facebookUser.fold(
          (failure) => emit(
              const FacebookSignInFailure(errorMessage: serverFailureMessage)),
          (facebookUserEntity) => emit(
              FacebookSignInSuccess(facebookUserEntity: facebookUserEntity)));
    } catch (e) {
      emit(FacebookSignInFailure(errorMessage: e.toString()));
    }
  }
}
