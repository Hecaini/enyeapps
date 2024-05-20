import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../screens.dart';

class AppointmentServices {

  static const SET_SERVICE_APP = 'set_service_appointment';
  static const GET_ON_PROCESS_APP = 'get_on_process_app';

  //edit TO ON PROCESS in database
  static Future<String> setServiceAppointment(String svcId, String startDate, String endDate, String notes,
      String engineerIds, String technicianIds, String assignedBy) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = SET_SERVICE_APP;
      map['svcId'] = svcId;
      map['startDate'] = startDate;
      map['endDate'] = endDate;
      map['notes'] = notes;
      map['engineerIds'] = engineerIds;
      map['technicianIds'] = technicianIds;
      map['assignedBy'] = assignedBy;

      final res = await http.post(Uri.parse(API.appointmentData), body: map); //passing value to result
      print('Set Appointment: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<AppointmentData>> getOnProcessAppointment() async {

    var map = Map<String, dynamic>();
    map['action'] = GET_ON_PROCESS_APP;

    //get all data of categories
    final res = await http.post(Uri.parse(API.appointmentData), body: map); //passing value to result
    print('getOnProcess Appoint Response: ${res.body}');

    if(res.statusCode == 200){
      List<AppointmentData> list = parseResponseOPApp(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<AppointmentData> parseResponseOPApp(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<AppointmentData>((json) => AppointmentData.fromJson(json)).toList();
  }
}