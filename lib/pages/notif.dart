import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:cs_compas/anouncement_controllers/util.dart';
import 'package:cs_compas/controllers/color_control.dart';
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
      backgroundColor: AppColors.backgroundColor,
      body: ValueListenableBuilder(
        valueListenable: dataNotifier,
        builder: (context, Announcement? value, child) {
          if (value == null) {
            return const Center(child: Text('No announcements found'));
          }
          return RefreshIndicator(
            onRefresh: _syncData,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: value.sessions.length,
              itemBuilder: (context, index) {
                final session = value.sessions[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  decoration: templateContainer(),
                  child: ExpansionTile(
                    backgroundColor: AppColors.neutral,
                    initiallyExpanded: index == 0 ? true : false,
                    iconColor: AppColors.textDark,
                    collapsedIconColor: AppColors.textDark,
                    title: Text(
                      session.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: AppColors.dark,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //collapsable announcements
                      //body
                      Text(
                        session.body.toString(),
                        style: const TextStyle(
                            fontSize: 16.0, color: AppColors.dark),
                        textAlign: TextAlign.justify,
                      ),
                      //Link
                      GestureDetector(
                        onTap: () => _launchUrl(
                            Uri.parse(session.link.toString()), false),
                        child: session.link.isEmpty
                            ? const Text("")
                            : const Text(
                                "Click Here!",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      //Sender
                      Row(
                        children: [
                          Text(
                            // Join sender names with comma
                            "From: ${session.sender.join(', ')}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: AppColors.dark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          //date
                          Text(
                            "${session.dateTimeFrom.year.toString()}/${session.dateTimeFrom.month.toString()}/${session.dateTimeFrom.day.toString()} | ${session.dateTimeFrom.hour.toString()}:${session.dateTimeFrom.minute.toString()}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: AppColors.dark,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _syncData(),
        backgroundColor: AppColors.dark,
        mini: true,
        heroTag: "button announcement",
        tooltip: 'Sync',
        child: const Icon(
          Icons.announcement_rounded,
          color: AppColors.tertiary,
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
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.dark)),
              SizedBox(height: 8.0),
              Text(
                'Loading...',
                style: TextStyle(color: AppColors.tertiary),
              )
            ],
          ),
        );
      },
    );
  }

  BoxDecoration templateContainer() {
    return BoxDecoration(
      color: AppColors.midtone,
      border: Border.all(color: AppColors.borderColor, width: 4),
      boxShadow: const [BoxShadow(offset: Offset(2, 3))],
    );
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
