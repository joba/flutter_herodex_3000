import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_herodex_3000/utils/logger.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;
  NetworkManager._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;

  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  /// Initialize the network manager and start listening to connectivity changes
  void initialize() {
    AppLogger.log('Initializing NetworkManager');

    // Check initial connectivity status
    _connectivity.checkConnectivity().then((result) {
      _updateConnectionStatus(result);
    });

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final wasConnected = _isConnected;
    _isConnected = !result.contains(ConnectivityResult.none);

    AppLogger.log(
      'Network status changed: ${_isConnected ? "Connected" : "Disconnected"}',
    );

    // Notify listeners of connection status change
    if (wasConnected != _isConnected) {
      _connectionStatusController.add(_isConnected);
    }
  }

  /// Check if currently connected to the internet
  bool get isConnected => _isConnected;

  /// Dispose the subscription when no longer needed
  void dispose() {
    AppLogger.log('Disposing NetworkManager');
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _connectionStatusController.close();
  }
}
