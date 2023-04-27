import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl({required this.profileRemoteDataSource});

  @override
  Future<Either<Failure, Stream<UserProfileEntity>>> getSingleUser() async {
    try {
      final response = profileRemoteDataSource.getCurrentUser();
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editProfile(
      UserProfileEntity userProfileEntity) async {
    try {
      final response =
          await profileRemoteDataSource.editProfile(userProfileEntity);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
