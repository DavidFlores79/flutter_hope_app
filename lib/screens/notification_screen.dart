import 'package:flutter/material.dart';
import 'package:hope_app/widgets/widgets.dart';

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
