class SOData {
  String soId;
  String soNo;
  String tsisId;
  String eventId;
  String project;
  String address;
  String clientPerson;
  String tsisNo;
  String timeIn;
  String timeOut;
  String day;
  String dateSO;
  String systemProduct;
  String location;
  String complaint;
  String status;
  String remark;
  String service;
  String servicedBy;
  String conforme;
  String conformeSignature;
  String coc;
  String stat;

  SOData({
    required this.soId,
    required this.soNo,
    required this.tsisId,
    required this.eventId,
    required this.project,
    required this.address,
    required this.clientPerson,
    required this.tsisNo,
    required this.timeIn,
    required this.timeOut,
    required this.day,
    required this.dateSO,
    required this.systemProduct,
    required this.location,
    required this.complaint,
    required this.status,
    required this.remark,
    required this.service,
    required this.servicedBy,
    required this.conforme,
    required this.conformeSignature,
    required this.coc,
    required this.stat
  });

  factory SOData.fromJson(Map<String, dynamic> json) {
    return SOData(
      soId: json['so_id'] as String? ?? '',
      soNo: json['so_no'] as String? ?? '',
      tsisId: json['tsis_id'] as String? ?? '',
      eventId: json['event_id'] as String? ?? '',
      project: json['project'] as String? ?? '',
      address: json['address'] as String? ?? '',
      clientPerson: json['client_person'] as String? ?? '',
      tsisNo: json['tsis_no'] as String? ?? '',
      timeIn: json['time_in'] as String? ?? '',
      timeOut: json['time_out'] as String? ?? '',
      day: json['day'] as String? ?? '',
      dateSO: json['date_so'] as String? ?? '',
      systemProduct: json['system_product'] as String? ?? '',
      location: json['location'] as String? ?? '',
      complaint: json['complaint'] as String? ?? '',
      status: json['status'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      service: json['service'] as String? ?? '',
      servicedBy: json['serviced_by'] as String? ?? '',
      conforme: json['conforme'] as String? ?? '',
      conformeSignature: json['conforme_signature'] as String? ?? '',
      coc: json['coc'] as String? ?? '',
      stat: json['stat'] as String? ?? '',
    );
  }
}

class SOFilesData {
  String id;
  String soId;
  String name;
  String code;
  String location;

  SOFilesData({
    required this.id,
    required this.soId,
    required this.name,
    required this.code,
    required this.location,
  });

  factory SOFilesData.fromJson(Map<String, dynamic> json) {
    return SOFilesData(
      id: json['id'] as String? ?? '',
      soId: json['so_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}