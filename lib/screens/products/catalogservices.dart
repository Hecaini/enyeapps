import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../screens.dart';

class catalogsServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_CATALOGS = 'get_all_catalogs';
  static const ADD_CATALOGS = 'add_catalogs';
  static const EDIT_CATALOGS = 'edit_catalogs';
  static const DEL_CATALOGS = 'delete_catalogs';

  //get data categories from database
  static Future <List<Catalogs>> getCatalogs() async {

      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_CATALOGS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.catalogs), body: map); //passing value to result
      print('getCatalogs Response: ${res.body}');

      if(res.statusCode == 200){
        List<Catalogs> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve catalogs');
        //return List<Categories>();
      }

  }

  static List<Catalogs> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Catalogs>((json) => Catalogs.fromJson(json)).toList();
  }

  //add categories in database
  static Future<String> addCatalogs(
      String model_name, String sized, String sale_price, String category_id, String subCat_id, String products_id, String manufacturer_id) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_CATALOGS;
      //name of category entered by user
      map['model_name'] = model_name;
      map['sized'] = sized;
      map['sale_price'] = sale_price;
      map['category_id'] = category_id;
      map['subCat_id'] = subCat_id;
      map['products_id'] = products_id;
      map['manufacturer_id'] = manufacturer_id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.catalogs), body: map); //passing value to result
      print('addCatalogs Response: ${res.body}');

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
  static Future<String> editCatalogs(
      String id, String model_name, String sized, String sale_price, String category_id, String subCat_id, String products_id, String manufacturer_id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_CATALOGS;
      map['id'] = id;
      map['model_name'] = model_name;
      map['sized'] = sized;
      map['sale_price'] = sale_price;
      map['category_id'] = category_id;
      map['subCat_id'] = subCat_id;
      map['products_id'] = products_id;
      map['manufacturer_id'] = manufacturer_id;

      final res = await http.post(Uri.parse(API.catalogs), body: map); //passing value to result
      print('editCatalogs Response: ${res.body}');

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
  static Future<String> deleteCatalogs(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_CATALOGS;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.catalogs), body: map); //passing value to result
      print('deleteCatalogs Response: ${res.body}');

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