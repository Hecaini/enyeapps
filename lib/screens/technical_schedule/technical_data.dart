//values na meron si categories
class TechnicalData {
  String id;
  String svcId;
  String svcTitle;
  String svcDesc;
  String dateSched;
  String timeSched;
  String clientId;
  String clientName;
  String clientCompany;
  String clientLocation;
  String clientProjName;
  String clientContact;
  String clientEmail;
  String status;

  TechnicalData({
    required this.id,
    required this.svcId,
    required this.svcTitle,
    required this.svcDesc,
    required this.dateSched,
    required this.timeSched,
    required this.clientId,
    required this.clientName,
    required this.clientCompany,
    required this.clientLocation,
    required this.clientProjName,
    required this.clientContact,
    required this.clientEmail,
    required this.status
  });

  factory TechnicalData.fromJson(Map<String, dynamic> json) {
    return TechnicalData(
      id: json['id'] as String,
      svcId: json['svc_id'] as String,
      svcTitle: json['svc_title'] as String,
      svcDesc: json['svc_desc'] as String,
      dateSched: json['date_sched'] as String,
      timeSched: json['time_sched'] as String,
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String,
      clientCompany: json['client_company'] as String,
      clientLocation: json['client_location'] as String,
      clientProjName: json['client_projectname'] as String,
      clientContact: json['client_contact'] as String,
      clientEmail: json['client_email'] as String,
      status: json['status'] as String,
    );
  }
}