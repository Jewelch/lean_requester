import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

abstract class ConnectivityMonitor {
  bool get isConnected;
  startMonitoring();
}

final class ConnectivityMonitorImpl implements ConnectivityMonitor {
  final Connectivity _connectivity;

  ConnectivityMonitorImpl(Connectivity connectivity) : _connectivity = connectivity;

  @visibleForTesting
  ConnectivityMonitorImpl.mock(Connectivity connectivity) : _connectivity = connectivity;

  @override
  bool get isConnected => connectionStateNotifier.value;

  final connectionStateNotifier = ValueNotifier<bool>(true);

  @override
  void startMonitoring() {
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      connectionStateNotifier.value = !connectionStateNotifier.value;
      connectionStateNotifier.value = connectivityResult != ConnectivityResult.none;
    });
  }
}
