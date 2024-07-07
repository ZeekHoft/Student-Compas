import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:cs_compas/anouncement_controllers/util.dart';
import 'package:cs_compas/calendar_controller/calendar_entity.dart';
import 'package:cs_compas/calendar_controller/util_calendar.dart';
import 'package:cs_compas/pages/calendar.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class LoadNotifCalendar {
  final util = Util();
  final utilCalendar =
      UtilCalendar(); // reference the uil file from both notif and calendar
  static final LoadNotifCalendar _instance = LoadNotifCalendar._internal();
  factory LoadNotifCalendar() =>
      _instance; // initialize fetching for this class
  LoadNotifCalendar._internal();

  Announcement? announcement;
  CalendarEvents? calendarEvents;

  Future<void> fetchDataAsync() async {
    // make a function that parses the values of which one is fetched first in firbase, could be the calendar first or the announcement after that load the rest
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      announcement = await util
          .parseJsonConfig(remoteConfig.getString(remoteUserDataKey))
          .catchError((errorAnnouncement) {
        return errorAnnouncement;
      });
      calendarEvents = await utilCalendar
          .parseJsonConfig(remoteConfig.getString(remoteCalendarKey))
          .catchError((errorCalender) {
        return errorCalender;
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error in load_notif_calendar.dart: $error");
      }
    }
  }
}
