import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';
import 'package:internship_practice/features/profile/domain/repositories/profile_repository.dart';

class EditProfileUseCase implements UseCase<String, Params> {
  final ProfileRepository profileRepository;

  const EditProfileUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await profileRepository.editProfile(params.userProfileEntity);
  }
}

class Params extends Equatable {
  final UserProfileEntity userProfileEntity;

  const Params({required this.userProfileEntity});

  @override
  List<Object?> get props => [userProfileEntity];
}
