import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:study_sphere_frontend/config/constants/enviroment.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketProvider with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    // Dart client
    _socket = IO.io('${Enviroment.api_url}/chats', {
      'transports': ['websocket'],
      'autoConnect': true,
      "forceNew": true,
      'extraHeaders': {'Authentication': token}
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
