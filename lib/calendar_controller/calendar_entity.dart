class CalendarEvents {
  final String event;

  final DateTime dateStart;
  final List<Session> sessions;

  CalendarEvents({
    required this.event,
    required this.dateStart,
    required this.sessions,
  });

  factory CalendarEvents.fromJson(Map<String, dynamic> json) => CalendarEvents(
      event: json["event"] as String,
      dateStart: DateTime.parse(json['dateStart'] as String),
      sessions: (json["sessions"] as List)
          .map((session) => Session.fromJson(session))
          .toList());
}

class Session {
  final String event;
  final DateTime dateStart;
  final String dayname;
  final String monthname;
  Session({
    required this.event,
    required this.dateStart,
    required this.dayname,
    required this.monthname,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        event: json['event'] as String,
        dayname: json['dayname'] as String,
        monthname: json['monthname'] as String,
        dateStart: DateTime.parse(json['dateStart'] as String),
      );
}
