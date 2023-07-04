import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../../screens.dart';

class productServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_PRODUCTS = 'get_all_products';
  static const ADD_PRODUCT = 'add_products';
  static const EDIT_PRODUCT = 'edit_products';
  static const DEL_PRODUCT = 'delete_products';

  //get data categories from database
  static Future <List<Products>> getProducts() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCTS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('getProducts Response: ${res.body}');

      if(res.statusCode == 200){
        List<Products> list = parseResponse(res.body);
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

  static List<Products> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Products>((json) => Products.fromJson(json)).toList();
  }

  //add categories in database
  static Future<String> addProducts(String name, String desc, String category_id, String subcategory_id) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_PRODUCT;
      //name of category entered by user
      map['name'] = name;
      map['desc'] = desc;
      map['category_id'] = category_id;
      map['subcategory_id'] = subcategory_id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('addProducts Response: ${res.body}');

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
  static Future<String> editProducts(String id, String name, String desc, String category_id, String subcategory_id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_PRODUCT;
      map['id'] = id;
      map['name'] = name;
      map['desc'] = desc;
      map['category_id'] = category_id;
      map['subcategory_id'] = subcategory_id;

      print('category id: ${category_id}');
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('editProducts Response: ${res.body}');

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
  static Future<String> deleteProducts(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_PRODUCT;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('deleteProducts Response: ${res.body}');

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