import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_users_usecase.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  final GetAllUsersUsecase getAllUsersUsecase;

  UserListCubit({
    required this.getAllUsersUsecase,
  }) : super(UserListInitial());

  Stream<List<UserEntity>> getAllUsers() {
    return getAllUsersUsecase.call(NoParams());
  }
}
