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
  final String dateStart;
  final String dateEnd;
  final String monthname;
  Session({
    required this.event,
    required this.dateStart,
    required this.dateEnd,
    required this.monthname,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        monthname: json['monthname'] as String,
        dateStart: json['dateStart'] as String,
        dateEnd: json['dateEnd'] as String,
        event: json['event'] as String,
      );
}
