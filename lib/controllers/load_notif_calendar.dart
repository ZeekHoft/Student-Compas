import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:cs_compas/anouncement_controllers/util.dart';
import 'package:cs_compas/calendar_controller/calendar_entity.dart';
import 'package:cs_compas/calendar_controller/util_calendar.dart';
import 'package:cs_compas/pages/calendar.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class LoadNotifCalendar {
  final util = Util();
  final utilCalendar = UtilCalendar();
  static final LoadNotifCalendar _instance = LoadNotifCalendar._internal();
  factory LoadNotifCalendar() => _instance;
  LoadNotifCalendar._internal();

  Announcement? announcement;
  CalendarEvents? calendarEvents;

  Future<void> fetchDataAsync() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    announcement =
        await util.parseJsonConfig(remoteConfig.getString(remoteUserDataKey));
    calendarEvents = await utilCalendar
        .parseJsonConfig(remoteConfig.getString(remoteCalendarKey));
  }
}
