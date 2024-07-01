class Announcement {
  final String title;
  final DateTime startsAt;
  final List<Session> sessions;

  Announcement({
    required this.title,
    required this.startsAt,
    required this.sessions,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        title: json['title'] as String,
        startsAt: DateTime.parse(json['startsAt'] as String),
        sessions: (json['sessions'] as List)
            .map((session) => Session.fromJson(session))
            .toList(),
      );

  get id => null;

  get color => null;

  get dateTimeFrom => null;

  get dateTimeTo => null;

  get sender => null;
}

class Session {
  final String id;
  final String color;
  final String title;
  final DateTime dateTimeFrom;
  final DateTime dateTimeTo;
  final List<String> sender;

  Session({
    required this.id,
    required this.color,
    required this.title,
    required this.dateTimeFrom,
    required this.dateTimeTo,
    required this.sender,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'] as String,
        color: json['color'] as String,
        title: json['title'] as String,
        dateTimeFrom: DateTime.parse(json['dateTimeFrom'] as String),
        dateTimeTo: DateTime.parse(json['dateTimeTo'] as String),
        sender: (json['sender'] as List).map((s) => s as String).toList(),
      );
}
