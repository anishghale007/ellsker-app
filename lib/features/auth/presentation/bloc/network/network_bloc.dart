import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/core/network/network_helper.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkInitial()) {
    on<NetworkObserveEvent>(_observe);
    on<NetworkNotifiyEvent>(_notifyStatus);
  }

  static final NetworkBloc _instance = NetworkBloc._();

  factory NetworkBloc() => _instance;

  void _observe(NetworkObserveEvent event, Emitter<NetworkState> emit) {
    NetworkHelper.observerNetwork();
  }

  void _notifyStatus(NetworkNotifiyEvent event, Emitter<NetworkState> emit) {
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailure());
  }
}
