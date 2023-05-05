import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class SendMessageUseCase implements UseCase<String, SendMessageParams> {
  final FirebaseRepository firebaseRepository;

  const SendMessageUseCase({required this.firebaseRepository});

  @override
  Future<Either<Failure, String>> call(SendMessageParams params) async {
    return await firebaseRepository.sendMessage(params.messageEntity);
  }
}

class SendMessageParams extends Equatable {
  final MessageEntity messageEntity;

  const SendMessageParams({required this.messageEntity});

  @override
  List<Object?> get props => [messageEntity];
}
