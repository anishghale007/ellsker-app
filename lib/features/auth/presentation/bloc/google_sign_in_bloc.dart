import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      GoogleSignInEvent event, Emitter<GoogleSignInState> emit) async {
    emit(GoogleSignInLoading());
    try {
      await gooogleLoginUseCase.call();
      emit(GoogleSignInSuccess());
    } catch (e) {
      emit(GoogleSignInFailure(errorMessage: e.toString()));
    }
  }
}
