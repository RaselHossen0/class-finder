class EventMedia {
  final int id;
  final String url;
  final String type;
  final int eventId;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventMedia({
    required this.id,
    required this.url,
    required this.type,
    required this.eventId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventMedia.fromJson(Map<String, dynamic> json) {
    return EventMedia(
      id: json['id'],
      url: json['url'],
      type: json['type'],
      eventId: json['eventId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Event {
  final int id;
  final String title;
  final DateTime date;
  final String description;
  final String location;
  final int classId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<EventMedia> eventMedia;
  final String className;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.location,
    required this.classId,
    required this.createdAt,
    required this.updatedAt,
    required this.eventMedia,
    required this.className,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var mediaList = json['EventMedia'] as List;
    List<EventMedia> eventMediaList =
        mediaList.map((i) => EventMedia.fromJson(i)).toList();
    // print(json);
    return Event(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      location: json['location'] ?? '',
      classId: json['classId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      eventMedia: eventMediaList,
      className: json['Class']['name'],
    );
  }
}
