import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../config/api_connection.dart';
import '../../screens.dart';

class SOServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_SO = 'get_so';
  static const GET_SO_DATA = 'get_so_data';
  static const SAVE_SO = 'save_so';
  static const UPDATE_SO = 'update_so';
  static const GET_ALL_SO = 'get_all_so';

  //get data categories from database
  static Future<List<GetSONumber>> getSONumber(String tsisId, String selectedDay, String eventId) async {

    var map = Map<String, dynamic>();
    map['action'] = GET_SO;
    map['tsis_id'] = tsisId;
    map['selectedDay'] = selectedDay;
    map['event_id'] = eventId;

    //get all data of categories
    final res = await http.post(Uri.parse(API.so_tsis), body: map); //passing value to result
    print('getSONumbers Response: ${res.body}');

    if(res.statusCode == 200){
      List<GetSONumber> list = parseResponse(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<GetSONumber> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GetSONumber>((json) => GetSONumber.fromJson(json)).toList();
  }

  static Future<List<SOData>> getServiceOrder(String so_id) async {

    var map = Map<String, dynamic>();
    map['action'] = GET_SO_DATA;
    map['so_id'] = so_id;

    //get all data of categories
    final res = await http.post(Uri.parse(API.so_tsis), body: map); //passing value to result
    print('getSO Response: ${res.body}');

    if(res.statusCode == 200){
      List<SOData> list = parseResponseSO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<SOData> parseResponseSO(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<SOData>((json) => SOData.fromJson(json)).toList();
  }

  static Future<List<SOData>> getAllServiceOrder() async {

    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_SO;

    //get all data of categories
    final res = await http.post(Uri.parse(API.so_tsis), body: map); //passing value to result
    print('getSO Response: ${res.body}');

    if(res.statusCode == 200){
      List<SOData> list = parseResponseAllSO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<SOData> parseResponseAllSO(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<SOData>((json) => SOData.fromJson(json)).toList();
  }

  static Future<String> saveSO(
      String svc_id, String so_id,
      String time_in, String time_out,
      String system_product, String location, String complaint,
      String status, String remark,
      String service, String serviced_by, String selectedDay,
      String conforme, String conformeEmail, String signCon, String signDataCon) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = SAVE_SO;
      //name of category entered by user
      map['svc_id'] = svc_id;
      map['so_id'] = so_id;
      map['time_in'] = time_in;
      map['time_out'] = time_out;
      map['system_product'] = system_product;
      map['location'] = location;
      map['complaint'] = complaint;
      map['status'] = status;
      map['remark'] = remark;
      map['service'] = service;
      map['serviced_by'] = serviced_by;
      map['selectedDay'] = selectedDay;
      map['conforme'] = conforme;
      map['conformeEmail'] = conformeEmail;
      map['signCon'] = signCon;
      map['signDataCon'] = signDataCon;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.serviceOrderData), body: map); //passing value to result
      print('Update SO Response: ${res.body}');

      //if status is okay in web server
      if(res.statusCode == 200){
        //return result from PHP backend
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> updateSO(
      String so_id, String time_in,
      String time_out, String system_product,
      String location, String complaint,
      String status, String remark,
      String service, String serviced_by,
      String conforme, String conformeEmail, String signCon, String signDataCon) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = UPDATE_SO;
      //name of category entered by user
      map['so_id'] = so_id;
      map['time_in'] = time_in;
      map['time_out'] = time_out;
      map['system_product'] = system_product;
      map['location'] = location;
      map['complaint'] = complaint;
      map['status'] = status;
      map['remark'] = remark;
      map['service'] = service;
      map['serviced_by'] = serviced_by;
      map['conforme'] = conforme;
      map['conformeEmail'] = conformeEmail;
      map['signCon'] = signCon;
      map['signDataCon'] = signDataCon;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.serviceOrderData), body: map); //passing value to result
      print('Update SO Response: ${res.body}');

      //if status is okay in web server
      if(res.statusCode == 200){
        //return result from PHP backend
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}