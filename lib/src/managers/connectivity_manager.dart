import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../observable.dart';
import '../helpers/debugging_printer.dart';

abstract interface class ConnectivityManager {
  Observable<bool> get isConnectedObs;
  bool get isConnected;
  startMonitoring();
}

final connectivityManager = ConnectivityManagerImpl(Connectivity());

class ConnectivityManagerImpl implements ConnectivityManager {
  final Connectivity connectivity;

  @override
  final isConnectedObs = Observable(true);

  ConnectivityManagerImpl(this.connectivity);

  @visibleForTesting
  ConnectivityManagerImpl.mock(this.connectivity);

  @override
  void startMonitoring() {
    Debugger.green("$ConnectivityManager has started");

    connectivity.onConnectivityChanged.listen((connectivityResult) {
      Debugger.green("$connectivityResult");
      isConnectedObs.value = !connectivityResult.contains(ConnectivityResult.none);
    });
  }

  @override
  bool get isConnected => isConnectedObs.value;
}
