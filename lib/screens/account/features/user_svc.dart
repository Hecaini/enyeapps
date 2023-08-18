import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/config.dart';
import '../../screens.dart';

class UsersInfoServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_USERS = 'get_all_users';

  //get data categories from database
  static Future <List<UsersInfo>> getUsersInfo() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_USERS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.users), body: map); //passing value to result
      print('getUsersInfo Response: ${res.body}');

      if(res.statusCode == 200){
        List<UsersInfo> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Users Info');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Users Info');
      //return List<Categories>();
    }
  }

  static List<UsersInfo> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UsersInfo>((json) => UsersInfo.fromJson(json)).toList();
  }
}