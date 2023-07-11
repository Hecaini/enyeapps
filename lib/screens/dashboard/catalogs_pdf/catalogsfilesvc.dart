import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../../screens.dart';

class catalogsFileSvc {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_FILECATALOGS = 'get_all_filecatalogs';
  static const ADD_FILECATALOGS = 'add_filecatalogs';
  static const EDIT_FILECATALOGS = 'edit_filecatalogs';
  static const DEL_FILECATALOGS= 'delete_filecatalogs';

  //get data categories from database
  static Future <List<CatalogsFile>> getFileCatalogs() async {

      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_FILECATALOGS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.fileCatalogs), body: map); //passing value to result
      print('getFileCatalogs Response: ${res.body}');

      if(res.statusCode == 200){
        List<CatalogsFile> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve categories');
      }
  }

  static List<CatalogsFile> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<CatalogsFile>((json) => CatalogsFile.fromJson(json)).toList();
  }

  //add categories in database
  static Future<String> addFileCatalogs(String name, String filename, String filedata) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = ADD_FILECATALOGS;
      //name of category entered by user
      map['name'] = name;
      map['filename'] = filename;
      map['filedata'] = filedata;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.fileCatalogs), body: map); //passing value to result
      print('addFileCatalogs Response: ${res.body}');
      print('addFileCatalogs Status: ${res.statusCode}');
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
  static Future<String> editFileCatalogs(String id, String name, String filename, String filedata) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_FILECATALOGS;
      map['id'] = id;
      map['name'] = name;
      map['filename'] = filename;
      map['filedata'] = filedata;

      final res = await http.post(Uri.parse(API.fileCatalogs), body: map); //passing value to result
      print('editFileCatalogs Response: ${res.body}');

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
  static Future<String> deleteFileCatalogs(String id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = DEL_FILECATALOGS;
      map['id'] = id;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.fileCatalogs), body: map); //passing value to result
      print('deleteFileCatalogs Response: ${res.body}');

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