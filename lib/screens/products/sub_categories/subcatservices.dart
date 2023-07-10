import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../../screens.dart';

class subCatServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_SUBCATEGORIES = 'get_all_subcat';
  static const ADD_SUBCATEGORIES = 'add_subcat';
  static const EDIT_SUBCATEGORIES = 'edit_subcat';
  static const DEL_SUBCATEGORIES = 'delete_subcat';

  //get data categories from database
  static Future <List<subCategories>> getSubCategories() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_SUBCATEGORIES;

      //get all data of categories
      final res = await http.post(Uri.parse(API.subcategories), body: map); //passing value to result
      print('getSubCategories Response: ${res.body}');

      if(res.statusCode == 200){
        List<subCategories> list = parseResponse(res.body);
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

  static List<subCategories> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<subCategories>((json) => subCategories.fromJson(json)).toList();
  }

  //add categories in database
  static Future<String> addSubCategories(String name, String category_id) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_SUBCATEGORIES;
      //name of category entered by user
      map['name'] = name;
      map['category_id'] = category_id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.subcategories), body: map); //passing value to result
      print('addSubCategories Response: ${res.body}');

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
  static Future<String> editSubCategories(String id, String name, String category_id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_SUBCATEGORIES;
      map['id'] = id;
      map['name'] = name;
      map['category_id'] = category_id;

      print('category id: ${category_id}');
      final res = await http.post(Uri.parse(API.subcategories), body: map); //passing value to result
      print('editSubCategories Response: ${res.body}');

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
  static Future<String> deleteSubCategories(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_SUBCATEGORIES;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.subcategories), body: map); //passing value to result
      print('deleteSubCategories Response: ${res.body}');

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