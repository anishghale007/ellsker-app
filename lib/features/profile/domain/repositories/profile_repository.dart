import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Stream<UserProfileEntity>>> getSingleUser();
  Future<Either<Failure, String>> editProfile(
      UserProfileEntity userProfileEntity);
}
