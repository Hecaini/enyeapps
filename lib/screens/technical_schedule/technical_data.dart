//values na meron si categories
class TechnicalData {
  String id;
  String svcId;
  String svcName;
  String svcDesc;
  String dateSched;
  String timeSched;
  String clientId;
  String status;

  TechnicalData({
    required this.id,
    required this.svcId,
    required this.svcName,
    required this.svcDesc,
    required this.dateSched,
    required this.timeSched,
    required this.clientId,
    required this.status
  });

  factory TechnicalData.fromJson(Map<String, dynamic> json) {
    return TechnicalData(
      id: json['id'] as String,
      svcId: json['svc_id'] as String,
      svcName: json['svc_name'] as String,
      svcDesc: json['svc_desc'] as String,
      dateSched: json['date_sched'] as String,
      timeSched: json['time_sched'] as String,
      clientId: json['client_id'] as String,
      status: json['status'] as String,
    );
  }
}