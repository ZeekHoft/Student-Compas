import 'package:cs_compas/calendar_controller/calendar_entity.dart';
import 'package:cs_compas/calendar_controller/util_calendar.dart';
import 'package:cs_compas/controllers/color_control.dart';
import 'package:cs_compas/controllers/default_calendar.dart';
import 'package:cs_compas/controllers/load_notif_calendar.dart';
import 'package:cs_compas/controllers/timeline.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const remoteCalendarKey = "events";

class ValueDateNotifier extends ValueNotifier<CalendarEvents?> {
  ValueDateNotifier() : super(null);
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final notifierData = ValueDateNotifier();
  final utilCalendar = UtilCalendar();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await LoadNotifCalendar().fetchDataAsync();
      notifierData.value = LoadNotifCalendar().calendarEvents;
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
                colors: [
              AppColors.backgroundColor,
              AppColors.backgroundColor
            ])),
        child: ValueListenableBuilder(
          valueListenable: notifierData,
          builder: (context, CalendarEvents? value, child) {
            if (value == null) {
              return const Center(child: DefaultCalendar());
            }

            return Timeline(
              sessions: value.sessions,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "button calendar",
        mini: true,
        backgroundColor: AppColors.black,
        onPressed: () => _syncDataCalendar(),
        tooltip: 'Sync Calendar',
        child: const Icon(
          Icons.calendar_month_outlined,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Future<void> _syncDataCalendar() async {
    //refreshes the announcemnts and forces to call every last one
    showLoadingWidget(context);
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Force fetch on every call
      ));
      await remoteConfig.fetchAndActivate();
      final rs = remoteConfig.getString(remoteCalendarKey);
      notifierData.value = await utilCalendar.parseJsonConfig(rs);
      Navigator.pop(context); // hide loading
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showLoadingWidget(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.black)),
              SizedBox(height: 8.0),
              Text(
                'Loading...',
                style: TextStyle(color: AppColors.primaryColor),
              )
            ],
          ),
        );
      },
    );
  }
}
