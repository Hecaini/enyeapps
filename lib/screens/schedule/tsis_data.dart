class TSISData {
  String tsisId;
  String tsisNo;
  String formNo;
  String projId;
  String project;
  String location;
  String clientName;
  String contactPerson;
  String contactNumber;
  String email;
  String problem;
  String subject;
  String other;
  String subjectChild;
  String remarks;
  String costAnalysis;
  String poForms;
  String quoteNo;
  String projectInfo;
  String status;
  String preparedBy;
  String personCharge;
  String technician;
  String attachment;
  String dateCompleted;

  TSISData({
    required this.tsisId,
    required this.tsisNo,
    required this.formNo,
    required this.projId,
    required this.project,
    required this.location,
    required this.clientName,
    required this.contactPerson,
    required this.contactNumber,
    required this.email,
    required this.problem,
    required this.subject,
    required this.other,
    required this.subjectChild,
    required this.remarks,
    required this.costAnalysis,
    required this.poForms,
    required this.quoteNo,
    required this.projectInfo,
    required this.status,
    required this.preparedBy,
    required this.personCharge,
    required this.technician,
    required this.attachment,
    required this.dateCompleted,
  });

  factory TSISData.fromJson(Map<String, dynamic> json) {
    return TSISData(
      tsisId: json['tsis_id'] as String? ?? '',
      tsisNo: json['tsis_no'] as String? ?? '',
      formNo: json['form_no'] as String? ?? '',
      projId: json['proj_id'] as String? ?? '',
      project: json['project'] as String? ?? '',
      location: json['location'] as String? ?? '',
      clientName: json['client_name'] as String? ?? '',
      contactPerson: json['contact_person'] as String? ?? '',
      contactNumber: json['contact_number'] as String? ?? '',
      email: json['email'] as String? ?? '',
      problem: json['problem'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      other: json['other'] as String? ?? '',
      subjectChild: json['subject_child'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      costAnalysis: json['cost_analysis'] as String? ?? '',
      poForms: json['po_forms'] as String? ?? '',
      quoteNo: json['quote_no'] as String? ?? '',
      projectInfo: json['project_info'] as String? ?? '',
      status: json['status'] as String? ?? '',
      preparedBy: json['prepared_by'] as String? ?? '',
      personCharge: json['person_charge'] as String? ?? '',
      technician: json['technician'] as String? ?? '',
      attachment: json['attachment'] as String? ?? '',
      dateCompleted: json['date_completed'] as String? ?? '',
    );
  }
}