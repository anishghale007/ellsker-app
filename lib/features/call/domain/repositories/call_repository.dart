import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/call/domain/entities/video_call_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';

abstract class CallRepository {
  Future<Either<Failure, VideoCallEntity>> getRtcToken(
      GetRtcTokenParams params);
}
