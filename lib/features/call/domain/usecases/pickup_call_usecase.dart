import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';

class PickupCallUsecase implements UseCase<void, PickupCallParams> {
  final CallRepository callRepository;

  const PickupCallUsecase({required this.callRepository});

  @override
  Future<Either<Failure, void>> call(PickupCallParams params) async {
    return await callRepository.pickupCall(params);
  }
}

class PickupCallParams extends Equatable {
  final String userId;

  const PickupCallParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
