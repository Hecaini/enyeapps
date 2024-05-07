//values na meron si categories
class ServiceOrderData {
  String soId;
  String soNo;
  String svcId;
  String project;
  String address;
  String clientPerson;
  String svcNo;
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
  String stat;

  ServiceOrderData({
    required this.soId,
    required this.soNo,
    required this.svcId,
    required this.project,
    required this.address,
    required this.clientPerson,
    required this.svcNo,
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
    required this.stat
  });

  factory ServiceOrderData.fromJson(Map<String, dynamic> json) {
    return ServiceOrderData(
      soId: json['so_id'] as String,
      soNo: json['so_no'] as String,
      svcId: json['svc_id'] as String,
      project: json['project'] as String,
      address: json['address'] as String,
      clientPerson: json['client_person'] as String,
      svcNo: json['svc_no'] as String,
      timeIn: json['time_in'] as String,
      timeOut: json['time_out'] as String,
      day: json['day'] as String,
      dateSO: json['date_so'] as String,
      systemProduct: json['system_product'] as String,
      location: json['location'] as String,
      complaint: json['complaint'] as String,
      status: json['status'] as String,
      remark: json['remark'] as String,
      service: json['service'] as String,
      servicedBy: json['serviced_by'] as String,
      conforme: json['conforme'] as String,
      conformeSignature: json['conforme_signature'] as String,
      stat: json['stat'] as String,
    );
  }
}

class GetSONumber {
  String dayCount;
  String soNo;
  String soStatus;
  String soId;

  GetSONumber({
    required this.dayCount,
    required this.soNo,
    required this.soStatus,
    required this.soId
  });

  factory GetSONumber.fromJson(Map<String, dynamic> json) {
    return GetSONumber(
      dayCount: json['dayCount'] as String,
      soNo: json['so_no'] as String,
      soStatus: json['so_status'] as String,
      soId: json['so_id'] as String,
    );
  }
}