import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/shared/preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { onLine, offLine, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;
  bool get socketConnected => _socket.connected;

  final storage = const FlutterSecureStorage();

  void connect() async {
    // Dart client
    String wssToken = await storage.read(key: 'wssToken') ?? '';
    String wssServer = Preferences.wssServer;
    User apiUser = (Preferences.apiUser != '')
        ? User.fromJson(Preferences.apiUser)
        : User();

    _socket = IO.io(wssServer, {
      'transports': ['websocket'],
      'autoConnect': true,
      // 'forceNew': true,
      'extraHeaders': {'x-token': wssToken, 'x-id': apiUser.id},
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.onLine;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }

  void checkConnection() {
    if (serverStatus != ServerStatus.onLine) {
      connect();
    }
  }

  void sendWsMessage(moduleName, type, data, [message = '']) {
    try {
      _socket.emit(moduleName, {
        'message': message,
        'type': type,
        'data': data != null && data is! List ? data.toMap() : data,
      });
    } catch (e) {
      print('*********  Error WS: $e');
      _socket.emit('system-log', {'message': 'E: $e'});
    }
  }

  void sendWsLog([message = '']) {
    try {
      final User apiUser = (Preferences.apiUser != '')
          ? User.fromJson(Preferences.apiUser)
          : User();
      _socket.emit('system-log', {
        'message': '${apiUser.nombre} ${apiUser.apellido} $message',
      });
    } catch (e) {
      print('***********  Error WS: $e');
      _socket.emit('system-log', {'message': 'E: $e'});
    }
  }
}
