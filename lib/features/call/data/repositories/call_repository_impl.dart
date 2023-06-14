import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/network/network_info.dart';
import 'package:internship_practice/features/call/data/datasources/call_remote_data_source.dart';
import 'package:internship_practice/features/call/domain/entities/call_entity.dart';
import 'package:internship_practice/features/call/domain/entities/rtc_token_entity.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';
import 'package:internship_practice/features/call/domain/usecases/end_call_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/make_call_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/pickup_call_usecase.dart';

class CallRepositoryImpl implements CallRepository {
  final CallRemoteDataSource callRemoteDataSource;
  final NetworkInfo networkInfo;

  const CallRepositoryImpl({
    required this.callRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RtcTokenEntity>> getRtcToken(
      GetRtcTokenParams params) async {
    if (await networkInfo.isConnected) {
      // if there is Internet connection
      try {
        final response = await callRemoteDataSource.getRtcToken(params);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // if there is not Internet connection
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> makeCall(MakeCallParams params) async {
    if (await networkInfo.isConnected) {
      // if there is Internet connection
      try {
        final response = await callRemoteDataSource.makeCall(params);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // if there is not Internet connection
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> endCall(EndCallParams params) async {
    if (await networkInfo.isConnected) {
      // if there is Internet connection
      try {
        final response = await callRemoteDataSource.endCall(params);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // if there is not Internet connection
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CallEntity>>> getAllCallLogs(
      String userId) async {
    try {
      final response = await callRemoteDataSource.getAllChatLogs(userId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> pickupCall(PickupCallParams params) async {
    try {
      final response = await callRemoteDataSource.pickupCall(params);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
