import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagePopUP extends StatefulWidget {
  const MessagePopUP({super.key});

  @override
  State<MessagePopUP> createState() => _MessagePopUPState();
}

class _MessagePopUPState extends State<MessagePopUP> {
  Map payload = {};
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    //re direct the user from any scene to the mssge screen
    //for background and termiated state

    if (data is RemoteMessage) {
      payload = data.data;
    }
    // for foreground dtate
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: Center(
        child: Column(
          children: [Text(payload.toString())],
        ),
      ),
    );
  }
}
