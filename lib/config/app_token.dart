import 'package:http/http.dart' as http;

import '../../config/config.dart';

class TokenServices {

  static Future<String> updateToken(String fcmToken, String user_id) async {
    try{
      var map = Map<String, dynamic>();
      map['fcmToken'] = fcmToken;
      map['user_id'] = user_id;

      final res = await http.post(Uri.parse(API.token), body: map); //passing value to result
      print('Token Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

}