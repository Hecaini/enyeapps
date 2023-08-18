import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../config/config.dart';
import '../../../screens.dart';

class DepartmentServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_DEPARTMENT = 'get_all_department';
  static const ADD_DEPARTMENT = 'add_dept';
  static const EDIT_DEPARTMENT = 'edit_dept';
  static const DEL_DEPARTMENT = 'delete_dept';

  //get data department from database
  static Future <List<Department>> getDepartments() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_DEPARTMENT;

      //get all data of categories
      final res = await http.post(Uri.parse(API.department), body: map); //passing value to result
      print('getDepartments Response: ${res.body}');

      if(res.statusCode == 200){
        List<Department> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Departments');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Departments');
      //return List<Categories>();
    }
  }

  static List<Department> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Department>((json) => Department.fromJson(json)).toList();
  }

  //add department in database
  static Future<String> addDepartment(String name, String shname) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_DEPARTMENT;
      //name of category entered by user
      map['name'] = name;
      map['shname'] = shname;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.department), body: map); //passing value to result
      print('addDepartment Response: ${res.body}');

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
  static Future<String> editDepartment(String id, String name, String shname) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_DEPARTMENT;
      map['id'] = id;
      map['name'] = name;
      map['shname'] = shname;

      final res = await http.post(Uri.parse(API.department), body: map); //passing value to result
      print('editDepartment Response: ${res.body}');

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
  static Future<String> deleteDepartment(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_DEPARTMENT;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.department), body: map); //passing value to result
      print('deleteDepartment Response: ${res.body}');

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