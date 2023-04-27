part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class SendNotificationEvent extends NotificationEvent {
  final NotificationEntity notificationEntity;

  const SendNotificationEvent({required this.notificationEntity});

  @override
  List<Object> get props => [notificationEntity];
}
