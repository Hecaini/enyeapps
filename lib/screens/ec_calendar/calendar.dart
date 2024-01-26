class CalendarData {
  String id;
  String title;
  String description;
  String color;
  String start;
  String end;

  CalendarData({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.start,
    required this.end,
  });

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      color: json['color'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
    );
  }
}