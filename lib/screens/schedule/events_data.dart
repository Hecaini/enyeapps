class EventsData {
  String id;
  String tsisId;
  String title;
  String ecColor;
  String engineer;
  String technician;
  String start;
  String end;
  String soNo;
  String status;
  String dateCompleted;
  String remarks;

  EventsData({
    required this.id,
    required this.tsisId,
    required this.title,
    required this.ecColor,
    required this.engineer,
    required this.technician,
    required this.start,
    required this.end,
    required this.soNo,
    required this.status,
    required this.dateCompleted,
    required this.remarks,
  });

  factory EventsData.fromJson(Map<String, dynamic> json) {
    return EventsData(
      id: json['id'] as String? ?? '',
      tsisId: json['tsis_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      ecColor: json['color'] as String? ?? '',
      engineer: json['engineer'] as String? ?? '',
      technician: json['technician'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      soNo: json['so_no'] as String? ?? '',
      status: json['status'] as String? ?? '',
      dateCompleted: json['date_completed'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
    );
  }
}