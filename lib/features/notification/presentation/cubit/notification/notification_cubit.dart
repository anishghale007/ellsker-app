import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/notification/domain/usecases/send_notification_usecase.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final SendNotificationUseCase sendNotificationUseCase;

  NotificationCubit({
    required this.sendNotificationUseCase,
  }) : super(NotificationInitial());

  Future<void> sendNotification(
      {required NotificationEntity notificationEntity}) async {
    try {
      final response = await sendNotificationUseCase
          .call(Params(notificationEntity: notificationEntity));
      response.fold(
          (failure) =>
              emit(NotificationError(errorMessage: failure.toString())),
          (success) => emit(NotificationSuccess()));
    } catch (e) {
      emit(NotificationError(errorMessage: e.toString()));
    }
  }
}
