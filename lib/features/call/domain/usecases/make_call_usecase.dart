import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';

class MakeCallUsecase implements UseCase<void, MakeCallParams> {
  final CallRepository callRepository;

  const MakeCallUsecase({required this.callRepository});

  @override
  Future<Either<Failure, void>> call(MakeCallParams params) async {
    return await callRepository.makeCall(params);
  }
}

class MakeCallParams extends Equatable {
  final String callerId;
  final String callerName;
  final String callerPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String callStartTime;
  final String callEndTime;

  const MakeCallParams({
    required this.callerId,
    required this.callerName,
    required this.callerPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.callStartTime,
    required this.callEndTime,
  });

  @override
  List<Object?> get props => [
        callerId,
        callerName,
        callerPhotoUrl,
        receiverId,
        receiverName,
        receiverPhotoUrl,
        callStartTime,
        callEndTime,
      ];
}
