import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';

class EndCallUsecase implements UseCase<void, EndCallParams> {
  final CallRepository callRepository;

  const EndCallUsecase({required this.callRepository});

  @override
  Future<Either<Failure, void>> call(EndCallParams params) async {
    return await callRepository.endCall(params);
  }
}

class EndCallParams extends Equatable {
  final String callerId;
  final String callerPhotoUrl;
  final String callerName;
  final String receiverId;
  final String callStartTime;
  final String callEndTime;
  final bool didPickup;

  const EndCallParams({
    required this.callerId,
    required this.callerPhotoUrl,
    required this.callerName,
    required this.receiverId,
    required this.callStartTime,
    required this.callEndTime,
    required this.didPickup,
  });

  @override
  List<Object?> get props => [
        callerId,
        callerPhotoUrl,
        callerName,
        receiverId,
        callStartTime,
        callEndTime,
        didPickup,
      ];
}
