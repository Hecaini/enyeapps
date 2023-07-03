import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../../screens.dart';

class categoriesServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_CATEGORIES = 'get_all_cat';
  static const ADD_CATEGORIES = 'add_cat';
  static const EDIT_CATEGORIES = 'edit_cat';
  static const DEL_CATEGORIES = 'delete_cat';

  //get data categories from database
  static Future <List<Categories>> getCategories() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_CATEGORIES;

      //get all data of categories
      final res = await http.post(Uri.parse(API.categories), body: map); //passing value to result
      print('getCategories Response: ${res.body}');

      if(res.statusCode == 200){
        List<Categories> list = parseResponse(res.body);
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

  static List<Categories> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }

  //add categories in database
  static Future<String> addCategories(String name) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_CATEGORIES;
      //name of category entered by user
      map['name'] = name;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.categories), body: map); //passing value to result
      print('addCategories Response: ${res.body}');

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
  static Future<String> editCategories(String id, String name) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_CATEGORIES;
      map['id'] = id;
      map['name'] = name;

      final res = await http.post(Uri.parse(API.categories), body: map); //passing value to result
      print('editCategories Response: ${res.body}');

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
  static Future<String> deleteCategories(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_CATEGORIES;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.categories), body: map); //passing value to result
      print('deleteCategories Response: ${res.body}');

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