import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:cs_compas/anouncement_controllers/util.dart';
import 'package:cs_compas/controllers/color_control.dart';
import 'package:cs_compas/controllers/load_notif_calendar.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: ValueListenableBuilder(
          valueListenable: dataNotifier,
          builder: (context, Announcement? value, child) {
            if (value == null) {
              return const Center(child: Text('No announcements found'));
            }
            return CustomRefreshIndicator(
              onRefresh: _syncData,
              builder: (context, child, controller) {
                return _refreshBuilder(controller, child);
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: value.sessions.length,
                itemBuilder: (context, index) {
                  final session = value.sessions[index];
                  return Stack(
                    children: [
                      _announcementItem(index == 0, session),
                      if (index == 0) _latestTag()
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _announcementItem(bool isFirst, Session session) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      decoration: BoxDecoration(
        color: AppColors.midtone,
        border: Border.all(color: AppColors.borderColor, width: 4),
        boxShadow: const [BoxShadow(offset: Offset(2, 3))],
      ),
      child: ExpansionTile(
        backgroundColor: AppColors.neutral,
        initiallyExpanded: isFirst ? true : false,
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
            style: const TextStyle(fontSize: 16.0, color: AppColors.dark),
            textAlign: TextAlign.justify,
          ),
          //Link
          GestureDetector(
            onTap: () => _launchUrl(Uri.parse(session.link.toString()), false),
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
  }

  Widget _latestTag() {
    return Positioned(
      top: 14,
      left: 8,
      child: Transform.rotate(
        angle: -0.2,
        child: SizedBox(
          height: 32,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: AppColors.tertiary,
                border: Border.all(color: AppColors.borderColor, width: 3),
                boxShadow: [BoxShadow(offset: Offset.fromDirection(1, 3))]),
            child: Row(
              children: [
                Text("Latest",
                    style: GoogleFonts.bebasNeue(
                        textStyle: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 19,
                            fontWeight: FontWeight.bold))),
                const Icon(
                  Icons.new_releases_rounded,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _refreshBuilder(IndicatorController controller, Widget child) {
    // Label during pull to refresh
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        if (!controller.isIdle)
          Positioned(
              top: 40.0 * controller.value,
              child: switch (controller.isLoading) {
                true => const Row(
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        "   Loading",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark),
                      )
                    ],
                  ),
                false => Opacity(
                    opacity: controller.value.clamp(0.0, 0.80),
                    child: Row(
                      children: [
                        Icon(controller.value >= 1
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded),
                        Text(
                          controller.value >= 1
                              ? " Release to refresh"
                              : " Pull down to refresh",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
              }),
        Transform.translate(
          offset: Offset(0, 80.0 * controller.value),
          child: child,
        ),
      ],
    );
  }

  Future<void> _syncData() async {
    //refreshes the announcemnts and forces to call every last one
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Force fetch on every call
      ));
      await remoteConfig.fetchAndActivate();
      final rs = remoteConfig.getString(remoteUserDataKey);
      dataNotifier.value = await util.parseJsonConfig(rs);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
