import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/features/auth/domain/entities/google_user_entity.dart';
import 'package:internship_practice/features/auth/domain/usecases/google_login_usecase.dart';
part 'google_sign_in_event.dart';
part 'google_sign_in_state.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final GooogleLoginUseCase gooogleLoginUseCase;

  GoogleSignInBloc({
    required this.gooogleLoginUseCase,
  }) : super(GoogleSignInInitial()) {
    on<GoogleUserEvent>(_googleSignIn);
  }

  Future<void> _googleSignIn(
      GoogleUserEvent event, Emitter<GoogleSignInState> emit) async {
    emit(GoogleSignInLoading());
    try {
      final googleUser = await gooogleLoginUseCase.call();
      googleUser.fold(
        (failure) =>
            emit(const GoogleSignInFailure(errorMessage: serverFailureMessage)),
        (googleUserEntity) =>
            emit(GoogleSignInSuccess(googleUserEntity: googleUserEntity)),
      );
    } catch (e) {
      emit(GoogleSignInFailure(errorMessage: e.toString()));
    }
  }
}
