import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internship_practice/features/auth/presentation/bloc/network/network_bloc.dart';

class NetworkHelper {
  static void observerNetwork() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        NetworkBloc().add(const NetworkNotifiyEvent());
      } else {
        NetworkBloc().add(const NetworkNotifiyEvent(isConnected: true));
      }
    });
  }
}
