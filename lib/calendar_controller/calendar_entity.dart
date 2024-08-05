class CalendarEvents {
  final String event;

  final List<Session> sessions;
  //require the parameters
  CalendarEvents({
    required this.event,
    required this.sessions,
  });

  factory CalendarEvents.fromJson(Map<String, dynamic> json) => CalendarEvents(
      //initialize them into a map type value
      event: json["event"] as String,
      sessions: (json["sessions"] as List)
          .map((session) => Session.fromJson(session))
          .toList());
}

//initialize the sub values of session
class Session {
  final String event;
  final int dayevent;
  final int monthnum;
  final int yearnum;

  Session(
      {required this.event,
      required this.dayevent,
      required this.monthnum,
      required this.yearnum});

  factory Session.fromJson(Map<String, dynamic> json) => Session(
      event: json['event'] as String,
      dayevent: DateTime.parse(json['dayevent'] as String).day,
      monthnum: DateTime.parse(json['monthnum'] as String).month,
      yearnum: DateTime.parse(json['yearnum'] as String).year);
}
