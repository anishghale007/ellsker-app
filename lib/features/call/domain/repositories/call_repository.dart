import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/call/domain/entities/call_entity.dart';
import 'package:internship_practice/features/call/domain/entities/rtc_token_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/end_call_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/make_call_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/pickup_call_usecase.dart';

abstract class CallRepository {
  Future<Either<Failure, RtcTokenEntity>> getRtcToken(GetRtcTokenParams params);
  Future<Either<Failure, void>> makeCall(MakeCallParams params);
  Future<Either<Failure, void>> pickupCall(PickupCallParams params);
  Future<Either<Failure, void>> endCall(EndCallParams params);
  Future<Either<Failure, List<CallEntity>>> getAllCallLogs(String userId);
}
