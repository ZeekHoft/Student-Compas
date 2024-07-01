import 'dart:convert';

import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:flutter/foundation.dart';

class Util {
  Future<Announcement> parseJsonConfig(String rawJson) async {
    final Map<String, dynamic> parsed =
        await compute(decodeJsonWithCompute, rawJson);
    final userEntity = Announcement.fromJson(parsed);
    return userEntity;
  }

  static Map<String, dynamic> decodeJsonWithCompute(String rawJson) {
    return jsonDecode(rawJson);
  }
}
