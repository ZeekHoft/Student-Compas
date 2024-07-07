import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:cs_compas/anouncement_controllers/util.dart';
import 'package:cs_compas/controllers/load_notif_calendar.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const remoteUserDataKey = "announcements";

class DataValueNotifier extends ValueNotifier<Announcement?> {
  DataValueNotifier() : super(null);
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final dataNotifier = DataValueNotifier();

  final util = Util();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await LoadNotifCalendar().fetchDataAsync();
      dataNotifier.value = LoadNotifCalendar().announcement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //disables back button

        title: const Text("Announcements:"),
      ),
      body: ValueListenableBuilder(
        valueListenable: dataNotifier,
        builder: (context, Announcement? value, child) {
          if (value == null) {
            return const Center(child: Text('No announcements found'));
          }
          return ListView.builder(
            itemCount: value.sessions.length,
            itemBuilder: (context, index) {
              final session = value.sessions[index];
              return Card(
                color: Colors.blue[800],
                child: ExpansionTile(
                  backgroundColor: Colors.blue[50],
                  title: Text(
                    "${session.title} ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  children: [
                    //collapsable announcements
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Text(
                        session.body.toString(),
                        style: TextStyle(color: Colors.grey[800]),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "\nSender: ${session.sender.join(', ')} • ",
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "\n ${session.dateTimeFrom.year.toString()}/${session.dateTimeFrom.month.toString()}/${session.dateTimeFrom.day.toString()}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Join sender names with comma
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _syncData(),
          heroTag: "button announcement",
          tooltip: 'Sync',
          child: const Icon(Icons.sync)),
    );
  }

  Future<void> _syncData() async {
    //refreshes the announcemnts and forces to call every last one
    showLoading(context);
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Force fetch on every call
      ));
      await remoteConfig.fetchAndActivate();
      final rs = remoteConfig.getString(remoteUserDataKey);
      dataNotifier.value = await util.parseJsonConfig(rs);
      Navigator.pop(context); // hide loading
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8.0),
              Text('Loading...')
            ],
          ),
        );
      },
    );
  }
}
