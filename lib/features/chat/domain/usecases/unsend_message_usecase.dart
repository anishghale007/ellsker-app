import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class UnsendMessageUseCase implements UseCase<void, UnsendMessageParams> {
  final ChatRepository chatRepository;

  const UnsendMessageUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, void>> call(params) async {
    return await chatRepository.unsendMessage(
      conversationId: params.conversationId,
      messageId: params.messageId,
    );
  }
}

class UnsendMessageParams extends Equatable {
  final String conversationId;
  final String messageId;

  const UnsendMessageParams({
    required this.conversationId,
    required this.messageId,
  });

  @override
  List<Object?> get props => [
        conversationId,
        messageId,
      ];
}
