import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    notifications = prefs.getStringList("notifications") ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Column(
        // Ensures vertical layout
        mainAxisAlignment: MainAxisAlignment.end, // Aligns content to bottom
        children: [
          // Home button row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/home"),
                label: const Icon(Icons.home),
              ),
            ],
          ),

          // Notification list (conditionally displayed)
          if (notifications.isNotEmpty)
            Flexible(
              // Controls list height within available space
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    title: Text(notification.split('-')[0].trim()),
                    subtitle: Text(notification.split('-')[1].trim()),
                  );
                },
              ),
            ),

          // "No notifications yet" message (displayed if empty)
          if (notifications.isEmpty)
            const Center(child: Text("No notifications yet")),
        ],
      ),
    );
  }
}
