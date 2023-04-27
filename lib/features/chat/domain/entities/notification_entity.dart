import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String token;
  final String title;
  final String body;

  const NotificationEntity({
    required this.token,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [
        token,
        title,
        body,
      ];
}
