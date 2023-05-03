import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';
import 'package:internship_practice/features/profile/domain/repositories/profile_repository.dart';

class GetCurrentUserUseCase
    implements UseCase<Stream<UserProfileEntity>, NoParams> {
  final ProfileRepository profileRepository;

  const GetCurrentUserUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, Stream<UserProfileEntity>>> call(
      NoParams noParams) async {
    return await profileRepository.getSingleUser();
  }
}
