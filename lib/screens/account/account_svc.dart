import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/api_connection.dart';
import '../screens.dart';

class AccountInfoServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_ACCOUNTS = 'get_all_accounts';

  //get data categories from database
  static Future <List<AccountInfo>> getAccountInfo() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_ACCOUNTS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.account), body: map); //passing value to result
      print('getAccountInfo Response: ${res.body}');

      if(res.statusCode == 200){
        List<AccountInfo> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Account Info');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve AccountInfo');
      //return List<Categories>();
    }
  }

  static List<AccountInfo> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<AccountInfo>((json) => AccountInfo.fromJson(json)).toList();
  }
}