import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:cs_compas/anouncement_controllers/util.dart';
import 'package:cs_compas/controllers/load_notif_calendar.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.white, Colors.white])),
        child: ValueListenableBuilder(
          valueListenable: dataNotifier,
          builder: (context, Announcement? value, child) {
            if (value == null) {
              return const Center(child: Text('No announcements found'));
            }
            return ListView.builder(
              itemCount: value.sessions.length,
              itemBuilder: (context, index) {
                final session = value.sessions[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Card(
                    color: Colors.amber,
                    child: Container(
                      decoration: templateContainer(),
                      child: ExpansionTile(
                        backgroundColor: Colors.amber,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        children: [
                          //collapsable announcements
                          //body
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              session.body.toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          //Link
                          Padding(
                            padding: const EdgeInsets.fromLTRB(11, 2, 2, 0),
                            child: GestureDetector(
                              onTap: () => _launchUrl(
                                  Uri.parse(session.link.toString()), false),
                              child: Text(
                                session.link.toString(),
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  decorationThickness: 3,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          //Sender
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "\nFrom: ${session.sender.join(', ')}",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                //date
                                Row(
                                  children: [
                                    Text(
                                      "${session.dateTimeFrom.year.toString()}/${session.dateTimeFrom.month.toString()}/${session.dateTimeFrom.day.toString()} | ${session.dateTimeFrom.hour.toString()}:${session.dateTimeFrom.minute.toString()}",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                        // Join sender names with comma
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _syncData(),
        backgroundColor: Colors.black,
        mini: true,
        heroTag: "button announcement",
        tooltip: 'Sync',
        child: const Icon(
          Icons.announcement_rounded,
          color: Colors.amber,
        ),
      ),
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
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              SizedBox(height: 8.0),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.amber),
              )
            ],
          ),
        );
      },
    );
  }

  BoxDecoration templateContainer() {
    return BoxDecoration(
        color: Colors.amber,
        border: Border.all(color: Colors.black, width: 4),
        borderRadius: const BorderRadius.all(Radius.circular(10)));
  }

  void _launchUrl(Uri uri, bool inAPP) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inAPP) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
          );
        } else {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("URI error in home.dart: ${e.toString()}");
      }
    }
  }
}
