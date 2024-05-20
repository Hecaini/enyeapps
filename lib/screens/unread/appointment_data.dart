class AppointmentData {
  String id;
  String svcId;
  String startDatetime;
  String endDatetime;
  String agenda;
  String location;
  String inCharge;
  String notes;
  String attachFile;
  String engineer;
  String technician;
  String assignedBy;
  String status;
  String category;

  AppointmentData({
    required this.id,
    required this.svcId,
    required this.startDatetime,
    required this.endDatetime,
    required this.agenda,
    required this.location,
    required this.inCharge,
    required this.notes,
    required this.attachFile,
    required this.engineer,
    required this.technician,
    required this.assignedBy,
    required this.status,
    required this.category,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      id: json['id'] as String,
      svcId: json['svc_id'] as String,
      startDatetime: json['start_datetime'] as String,
      endDatetime: json['end_datetime'] as String,
      agenda: json['agenda'] as String,
      location: json['location'] as String,
      inCharge: json['in_charge'] as String,
      notes: json['notes'] as String,
      attachFile: json['attach_file'] as String,
      engineer: json['engineer'] as String,
      technician: json['technician'] as String,
      assignedBy: json['assigned_by'] as String,
      status: json['status'] as String,
      category: json['category'] as String,
    );
  }
}