import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/auth/domain/usecases/sign_out_usecase.dart';

part 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  final SignOutUseCase signOutUseCase;

  SignOutCubit({
    required this.signOutUseCase,
  }) : super(SignOutInitial());

  Future<void> signOut() async {
    try {
      await signOutUseCase.call();
      emit(SignOutSuccess());
    } catch (e) {
      emit(SignOutFailure(errorMessage: e.toString()));
    }
  }
}
