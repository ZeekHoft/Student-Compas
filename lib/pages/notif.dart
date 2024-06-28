import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String? notificationTitle;
  String? notificationBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  label: Icon(Icons.home))
            ],
          ),
          Row(
            children: [
              FutureBuilder(
                future: _getNotificationData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data as Map<String, String>;
                    return Column(
                      children: [
                        if (data['title'] != null) Text(data['title']!),
                        if (data['body'] != null) Text(data['body']!),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>> _getNotificationData() async {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null &&
        arguments.containsKey('title') &&
        arguments.containsKey('body')) {
      notificationTitle = arguments['title'] as String?;
      notificationBody = arguments['body'] as String?;
      return {
        'title': notificationTitle ?? '',
        'body': notificationBody ?? '',
      };
    } else {
      return {};
    }
  }
}
