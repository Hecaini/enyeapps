import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../config/config.dart';
import '../../../screens.dart';

class PositionServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_POSITIONS = 'get_all_pos';
  static const ADD_POSITIONS = 'add_pos';
  static const EDIT_POSITIONS = 'edit_pos';
  static const DEL_POSITIONS = 'delete_pos';

  //get data department from database
  static Future <List<Position>> getPositions() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_POSITIONS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.position), body: map); //passing value to result
      print('getPosition Response: ${res.body}');

      if(res.statusCode == 200){
        List<Position> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Position');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Position');
      //return List<Categories>();
    }
  }

  static List<Position> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Position>((json) => Position.fromJson(json)).toList();
  }

  //add department in database
  static Future<String> addPosition(String position, String deptId) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_POSITIONS;
      //name of category entered by user
      map['position'] = position;
      map['deptId'] = deptId;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.position), body: map); //passing value to result
      print('addPosition Response: ${res.body}');

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

  //edit department in database
  static Future<String> editPosition(String id, String position, String deptId) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_POSITIONS;
      map['id'] = id;
      map['position'] = position;
      map['deptId'] = deptId;

      final res = await http.post(Uri.parse(API.position), body: map); //passing value to result
      print('editPosition Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //delete categories in database
  static Future<String> deletePosition(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_POSITIONS;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.position), body: map); //passing value to result
      print('deletePosition Response: ${res.body}');

      //if status is okay in web server
      if(res.statusCode == 200){

        //return result from PHP backend
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; //returning just an error just to make it simple..
    }
  }
}