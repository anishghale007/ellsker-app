import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';
import 'package:internship_practice/features/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:internship_practice/features/profile/domain/usecases/get_current_user_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final EditProfileUseCase editProfileUseCase;

  ProfileBloc({
    required this.getCurrentUserUseCase,
    required this.editProfileUseCase,
  }) : super(ProfileInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<EditProfileEvent>(_onEditProfile);
  }

  Future<void> _onGetCurrentUser(
      GetCurrentUserEvent event, Emitter<ProfileState> emit) async {
    final response = await getCurrentUserUseCase.call(NoParams());
    emit(ProfileLoading());
    response.fold(
        (failure) => emit(ProfileError(errorMessage: failure.toString())),
        (singleUser) => emit(ProfileLoaded(userProfileEntity: singleUser)));
  }

  Future<void> _onEditProfile(
      EditProfileEvent event, Emitter<ProfileState> emit) async {
    final editProfile = await editProfileUseCase
        .call(Params(userProfileEntity: event.userProfileEntity));
    emit(ProfileLoading());
    editProfile.fold(
        (failure) => emit(ProfileError(errorMessage: failure.toString())),
        (success) => emit(ProfileEditSuccess()));
  }
}
