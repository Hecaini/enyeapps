import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../screens.dart';

class TechnicalDataServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_TECHNICAL = 'get_all_technical';

  //get data categories from database
  static Future <List<TechnicalData>> getTechnicalData() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_TECHNICAL;

      //get all data of categories
      final res = await http.post(Uri.parse(API.technicalData), body: map); //passing value to result
      print('getTechnicalDatas Response: ${res.body}');

      if(res.statusCode == 200){
        List<TechnicalData> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Technical Data');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<TechnicalData> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TechnicalData>((json) => TechnicalData.fromJson(json)).toList();
  }
}