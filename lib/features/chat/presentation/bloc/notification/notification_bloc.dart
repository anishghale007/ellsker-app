import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/send_notification_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SendNotificationUseCase sendNotificationUseCase;

  NotificationBloc({
    required this.sendNotificationUseCase,
  }) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      on<SendNotificationEvent>(_onSendNotification);
    });
  }

  Future<void> _onSendNotification(
      SendNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      final response = await sendNotificationUseCase
          .call(Params(notificationEntity: event.notificationEntity));
      response.fold(
          (failure) =>
              emit(NotificationError(errorMessage: failure.toString())),
          (success) => emit(NotificationSuccess()));
    } catch (e) {
      emit(NotificationError(errorMessage: e.toString()));
    }
  }
}
