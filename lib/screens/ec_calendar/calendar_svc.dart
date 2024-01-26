import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../screens.dart';

class CalendarServices {

  //get handler data from database
  static Future <List<CalendarData>> calendarData(String firstDate, String lastDate) async {
    try {
      var map = Map<String, dynamic>();
      map['firstDate'] = firstDate;
      map['lastDate'] = lastDate;

      //get all data of categories
      final res = await http.post(Uri.parse(API.ec_calendar), body: map); //passing value to result
      print('Calendar Data Response: ${res.body}');

      if (res.statusCode == 200) {
        List<CalendarData> list = parseResHandler(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Calendar Data');
        return [];
      }
    } catch (e) {
      throw Exception('Failed to retrieve Calendar Data');
      return [];
    }
  }

  static List<CalendarData> parseResHandler(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<CalendarData>((json) => CalendarData.fromJson(json))
        .toList();
  }
}