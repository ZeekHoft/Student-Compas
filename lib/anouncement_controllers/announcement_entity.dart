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

  get link => null;

  get dateTimeFrom => null;

  get body => null;

  get sender => null;
}

class Session {
  final String id;
  final String link;
  final String title;
  final DateTime dateTimeFrom;
  final String body;
  final List<String> sender;

  Session({
    required this.id,
    required this.link,
    required this.title,
    required this.dateTimeFrom,
    required this.body,
    required this.sender,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'] as String,
        link: json['link'] as String,
        title: json['title'] as String,
        dateTimeFrom: DateTime.parse(json['dateTimeFrom'] as String),
        body: json['body'] as String,
        sender: (json['sender'] as List).map((s) => s as String).toList(),
      );
}
