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
  final String receiverId;
  final String callEndTime;

  const EndCallParams({
    required this.callerId,
    required this.receiverId,
    required this.callEndTime,
  });

  @override
  List<Object?> get props => [
        callerId,
        receiverId,
        callEndTime,
      ];
}
