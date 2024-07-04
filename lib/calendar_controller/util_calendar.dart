import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cs_compas/calendar_controller/calendar_entity.dart';

class UtilCalendar {
  Future<CalendarEvents> parseJsonConfig(String rawJson) async {
    final Map<String, dynamic> parsed =
        await compute(decodeJsonWithCompute, rawJson);
    final calendarEntity = CalendarEvents.fromJson(parsed);
    return calendarEntity;
  }

  static Map<String, dynamic> decodeJsonWithCompute(String rawJson) {
    return jsonDecode(rawJson);
  }
}
