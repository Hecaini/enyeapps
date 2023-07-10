import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../../screens.dart';

class mfrServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_MFR = 'get_all_mfr';
  static const ADD_MFR = 'add_mfr';
  static const EDIT_MFR = 'edit_mfr';
  static const DEL_MFR = 'delete_mfr';

  //get data categories from database
  static Future <List<Manufacturer>> getManufacturer() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_MFR;

      //get all data of categories
      final res = await http.post(Uri.parse(API.manufacturer), body: map); //passing value to result
      print('getManufacturer Response: ${res.body}');

      if(res.statusCode == 200){
        List<Manufacturer> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve categories');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve categories');
      //return List<Categories>();
    }
  }

  static List<Manufacturer> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Manufacturer>((json) => Manufacturer.fromJson(json)).toList();
  }

  //add categories in database
  static Future<String> addManufacturer(String name) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_MFR;
      //name of category entered by user
      map['name'] = name;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.manufacturer), body: map); //passing value to result
      print('addManufacturer Response: ${res.body}');

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

  //edit categories in database
  static Future<String> editManufacturer(String id, String name) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_MFR;
      map['id'] = id;
      map['name'] = name;

      final res = await http.post(Uri.parse(API.manufacturer), body: map); //passing value to result
      print('editManufacturer Response: ${res.body}');

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
  static Future<String> deleteManufacturer(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_MFR;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.manufacturer), body: map); //passing value to result
      print('deleteManufacturer Response: ${res.body}');

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