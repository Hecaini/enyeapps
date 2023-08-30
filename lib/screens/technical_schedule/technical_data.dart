//values na meron si categories
class TechnicalData {
  String id;
  String svcId;
  String service;
  String svcTitle;
  String svcDesc;
  String dateSched;
  String clientId;
  String clientName;
  String clientCompany;
  String clientLocation;
  String clientProjName;
  String clientContact;
  String clientEmail;
  String status;
  String svcHandler;
  String notesComplete;
  String assignedBy;

  TechnicalData({
    required this.id,
    required this.svcId,
    required this.service,
    required this.svcTitle,
    required this.svcDesc,
    required this.dateSched,
    required this.clientId,
    required this.clientName,
    required this.clientCompany,
    required this.clientLocation,
    required this.clientProjName,
    required this.clientContact,
    required this.clientEmail,
    required this.status,
    required this.svcHandler,
    required this.notesComplete,
    required this.assignedBy
  });

  factory TechnicalData.fromJson(Map<String, dynamic> json) {
    return TechnicalData(
      id: json['id'] as String,
      svcId: json['svc_id'] as String,
      service: json['service'] as String,
      svcTitle: json['svc_title'] as String,
      svcDesc: json['svc_desc'] as String,
      dateSched: json['date_sched'] as String,
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String,
      clientCompany: json['client_company'] as String,
      clientLocation: json['client_location'] as String,
      clientProjName: json['client_projectname'] as String,
      clientContact: json['client_contact'] as String,
      clientEmail: json['client_email'] as String,
      status: json['status'] as String,
      svcHandler: json['service_handler'] as String,
      notesComplete: json['notesComplete'] as String,
      assignedBy: json['assigned_by'] as String,
    );
  }
}