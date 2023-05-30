import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class UnsendMessageUseCase implements UseCase<void, UnsendMessageParams> {
  final ChatRepository chatRepository;

  const UnsendMessageUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, void>> call(UnsendMessageParams params) async {
    return await chatRepository.unsendMessage(params);
  }
}

class UnsendMessageParams extends Equatable {
  final String receiverId;
  final String senderId;
  final MessageType messageType;
  final String conversationId;
  final String messageId;

  const UnsendMessageParams({
    required this.receiverId,
    required this.senderId,
    required this.messageType,
    required this.conversationId,
    required this.messageId,
  });

  @override
  List<Object?> get props => [
        conversationId,
        messageId,
        receiverId,
        senderId,
        messageType,
      ];
}
