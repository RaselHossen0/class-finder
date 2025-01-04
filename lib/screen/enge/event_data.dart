class EventData {
  late String eventCaption;
  late int eventId;
  List<dynamic> eventImg=[];
  late String eventDescription;
  late String date;
  late String location;

  EventData({
    required this.eventCaption,
    required this.eventDescription,
    required this.eventId,
    required this.eventImg,
    required this.date,
    required this.location
  });
}
