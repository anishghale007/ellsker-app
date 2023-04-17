import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_users_usecase.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetAllUsersUsecase getAllUsersUsecase;

  UserListBloc({
    required this.getAllUsersUsecase,
  }) : super(UserListInitial()) {
    on<GetUserListEvent>(_getAllUSers);
  }

  Future<void> _getAllUSers(
      GetUserListEvent event, Emitter<UserListState> emit) async {
    emit(UserListLoading());
    try {
      final userList = getAllUsersUsecase.call();
      userList.listen((users) {
        emit(UserListLoaded(userList: users));
      });
    } catch (e) {
      emit(UserListError(errorMessage: e.toString()));
      log(e.toString());
      throw Exception(e);
    }
  }
}
