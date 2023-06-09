import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/call/domain/entities/call_log_entity.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';

class GetCallLogsUsecase
    implements UseCase<List<CallLogEntity>, GetCallLogsParams> {
  final CallRepository callRepository;

  const GetCallLogsUsecase({required this.callRepository});

  @override
  Future<Either<Failure, List<CallLogEntity>>> call(
      GetCallLogsParams params) async {
    return await callRepository.getAllCallLogs(params.userId);
  }
}

class GetCallLogsParams extends Equatable {
  final String userId;

  const GetCallLogsParams({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
