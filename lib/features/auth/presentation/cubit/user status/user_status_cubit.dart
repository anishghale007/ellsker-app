import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/auth/domain/usecases/set_user_status_usecase.dart';

part 'user_status_state.dart';

class UserStatusCubit extends Cubit<UserStatusState> {
  final SetUserStatusUseCase setUserStatusUseCase;

  UserStatusCubit({
    required this.setUserStatusUseCase,
  }) : super(UserStatusInitial());

  Future<void> setUserState(bool isOnline) async {
    try {
      final response = await setUserStatusUseCase
          .call(SetUserStatusParams(isOnline: isOnline));
      response.fold(
        (failure) => emit(UserStatusError(errorMessage: failure.toString())),
        (success) => emit(UserStatusSuccess()),
      );
    } catch (e) {
      emit(UserStatusError(errorMessage: e.toString()));
    }
  }
}
