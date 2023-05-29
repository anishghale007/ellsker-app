import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class GetAllSharedPhotosUseCase
    extends UseCase<List<String>, GetAllSharedPhotosParams> {
  final ChatRepository chatRepository;

  GetAllSharedPhotosUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, List<String>>> call(
      GetAllSharedPhotosParams params) async {
    return await chatRepository.getAllSharedPhotos(params.receiverId);
  }
}

class GetAllSharedPhotosParams extends Equatable {
  final String receiverId;

  const GetAllSharedPhotosParams({
    required this.receiverId,
  });

  @override
  List<Object?> get props => [
        receiverId,
      ];
}
