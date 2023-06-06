import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/call/domain/entities/video_call_entity.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';

class GetRtcTokenUsecase
    implements UseCase<VideoCallEntity, GetRtcTokenParams> {
  final CallRepository callRepository;

  const GetRtcTokenUsecase({required this.callRepository});

  @override
  Future<Either<Failure, VideoCallEntity>> call(
      GetRtcTokenParams params) async {
    return await callRepository.getRtcToken(params);
  }
}

class GetRtcTokenParams extends Equatable {
  final String channelName;
  final String role;
  final String tokenType;
  final String uid;

  const GetRtcTokenParams({
    required this.channelName,
    required this.role,
    required this.tokenType,
    required this.uid,
  });

  @override
  List<Object?> get props => [
        channelName,
        role,
        tokenType,
        uid,
      ];
}
