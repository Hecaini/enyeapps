import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../screens.dart';

class SODataServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_SO = 'get_so';

  //get data categories from database
  static Future<List<GetSONumber>> getSONumber(String svcId, String selectedDay) async {

      var map = Map<String, dynamic>();
      map['action'] = GET_SO;
      map['svc_id'] = svcId;
      map['selectedDay'] = selectedDay;

      //get all data of categories
      final res = await http.post(Uri.parse(API.serviceOrderData), body: map); //passing value to result
      print('getSONumbers Response: ${res.body}');

      if(res.statusCode == 200){
        List<GetSONumber> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Technical Data');
        //return List<Categories>();
      }
  }

  static List<GetSONumber> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GetSONumber>((json) => GetSONumber.fromJson(json)).toList();
  }
}