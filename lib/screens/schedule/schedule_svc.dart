import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../screens.dart';

class ScheduleDataServices {
  static const GET_PENDING_EVENTS = 'get_pending_events';
  static const GET_TSIS = 'get_tsis';

  static Future <List<EventsData>> getPendingEvents() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_PENDING_EVENTS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.ec_schedule), body: map); //passing value to result
      print('getEventsData Response: ${res.body}');

      if(res.statusCode == 200){
        List<EventsData> list = parseResponse(res.body);
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

  static List<EventsData> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EventsData>((json) => EventsData.fromJson(json)).toList();
  }

  static Future <List<TSISData>> getTSIS() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_TSIS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.ec_schedule), body: map); //passing value to result
      print('getTSISData Response: ${res.body}');

      if(res.statusCode == 200){
        List<TSISData> list = parseResTSIS(res.body);
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

  static List<TSISData> parseResTSIS(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TSISData>((json) => TSISData.fromJson(json)).toList();
  }
}