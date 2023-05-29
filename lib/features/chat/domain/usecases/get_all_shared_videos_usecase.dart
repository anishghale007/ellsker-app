import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class GetAllSharedVideosUseCase
    extends UseCase<List<String>, GetAllSharedVideosParams> {
  final ChatRepository chatRepository;

  GetAllSharedVideosUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, List<String>>> call(
      GetAllSharedVideosParams params) async {
    return await chatRepository.getAllSharedPhotos(params.receiverId);
  }
}

class GetAllSharedVideosParams extends Equatable {
  final String receiverId;

  const GetAllSharedVideosParams({
    required this.receiverId,
  });

  @override
  List<Object?> get props => [
        receiverId,
      ];
}
