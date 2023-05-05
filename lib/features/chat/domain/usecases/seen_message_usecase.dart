import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class SeenMessageUsecase implements UseCase<void, SeenMessageParams> {
  final FirebaseRepository firebaseRepository;

  const SeenMessageUsecase({required this.firebaseRepository});

  @override
  Future<Either<Failure, void>> call(SeenMessageParams params) async {
    return await firebaseRepository.seenMessage(params.conversationId);
  }
}

class SeenMessageParams extends Equatable {
  final String conversationId;

  const SeenMessageParams({required this.conversationId});
  @override
  List<Object?> get props => [conversationId];
}
