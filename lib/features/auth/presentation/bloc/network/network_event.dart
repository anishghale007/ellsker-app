part of 'network_bloc.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class NetworkObserveEvent extends NetworkEvent {}

class NetworkNotifiyEvent extends NetworkEvent {
  final bool isConnected;

  const NetworkNotifiyEvent({this.isConnected = false});
}
