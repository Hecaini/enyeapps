import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../screens.dart';

class TechnicalDataServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_TECHNICAL = 'get_all_technical';
  static const EDIT_TO_ON_PROCESS = 'edit_to_on_process';
  static const EDIT_TO_COMPLETED = 'edit_to_completed';
  static const EDIT_TO_SET_SCHED = 'edit_to_set_sched';

  //get data categories from database
  static Future <List<TechnicalData>> getTechnicalData() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_TECHNICAL;

      //get all data of categories
      final res = await http.post(Uri.parse(API.technicalData), body: map); //passing value to result
      print('getTechnicalDatas Response: ${res.body}');

      if(res.statusCode == 200){
        List<TechnicalData> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Technical Data');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<TechnicalData> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TechnicalData>((json) => TechnicalData.fromJson(json)).toList();
  }

  //edit TO ON PROCESS in database
  static Future<String> editToOnProcess(String id, String svcId, String personInCharge, String assignedBy) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_ON_PROCESS;
      map['id'] = id;
      map['svcId'] = svcId;
      map['personInCharge'] = personInCharge;
      map['assignedBy'] = assignedBy;

      final res = await http.post(Uri.parse(API.technicalData), body: map); //passing value to result
      print('editToOnProcess Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //edit TO TASK COMPLETED in database
  static Future<String> editTaskCompleted(String id, String svcId, String notes) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_COMPLETED;
      map['id'] = id;
      map['svcId'] = svcId;
      map['notes'] = notes;

      final res = await http.post(Uri.parse(API.technicalData), body: map); //passing value to result
      print('editToCompleted Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> pushNotif(String title, String body) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_COMPLETED;
      map['title'] = title;
      map['body'] = body;

      final res = await http.post(Uri.parse(API.pushNotif), body: map); //passing value to result
      print('pushNotif Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //edit TO ON PROCESS in database
  static Future<String> editToSetSched(String id, String svcId, String sDateSched, String eDateSched, String personInCharge, String assignedBy) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_SET_SCHED;
      map['id'] = id;
      map['svcId'] = svcId;
      map['sDateSched'] = sDateSched;
      map['eDateSched'] = eDateSched;
      map['personInCharge'] = personInCharge;
      map['assignedBy'] = assignedBy;

      final res = await http.post(Uri.parse(API.technicalData), body: map); //passing value to result
      print('editToSetSched Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

}