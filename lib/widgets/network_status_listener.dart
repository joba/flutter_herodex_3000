import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/managers/network_manager.dart';
import 'package:flutter_herodex_3000/utils/snackbar.dart';

class NetworkStatusListener extends StatefulWidget {
  final Widget child;
  const NetworkStatusListener({super.key, required this.child});

  @override
  State<NetworkStatusListener> createState() => _NetworkStatusListenerState();
}

class _NetworkStatusListenerState extends State<NetworkStatusListener> {
  StreamSubscription<bool>? _networkSubscription;
  bool _hasShownDisconnectedMessage = false;

  @override
  void initState() {
    super.initState();
    _networkSubscription = NetworkManager().connectionStatus.listen((
      isConnected,
    ) {
      if (mounted) {
        if (!isConnected && !_hasShownDisconnectedMessage) {
          _hasShownDisconnectedMessage = true;
          AppSnackBar.of(context).showError('No internet connection');
        } else if (isConnected && _hasShownDisconnectedMessage) {
          _hasShownDisconnectedMessage = false;
          AppSnackBar.of(context).showSuccess('Connection restored');
        }
      }
    });
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
