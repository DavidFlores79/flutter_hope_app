import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = 'notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Notificaciones'),
        actions: const [
          // PopupMenuList(),
        ],
      ),
      body: const Center(
        child: Text('Notificaciones'),
      ),
    );
  }
}
