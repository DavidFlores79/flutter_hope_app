import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { onLine, offLine, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;
  bool get socketConnected => _socket.connected;

  void connect() {
    // Dart client
    _socket = IO.io('http://172.17.1.45:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
      // 'forceNew': true,
      'extraHeaders': {
        'x-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2NWM3ODljMTMzODE1ZDRmNzY1NzUxNGQiLCJpYXQiOjE3MDg2MTIzNjksImV4cCI6MTcwODY5ODc2OX0.Bwvo5K0kNslKZ6zH7hYS8zRWnGp34LHsK35J2TFTvJs'
      },
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

  void sendWsMessage(moduleName, type, DocumentLine data, [message = '']) {
    _socket.emit(moduleName, {
      'message': message,
      'type': type,
      'data': data.toMap(),
    });
  }
}
