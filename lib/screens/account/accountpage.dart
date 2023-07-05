import 'dart:convert';

import 'package:enye_app/screens/login/useradmin.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/api_connection.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/account';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => AccountPage()
    );
  }

  @override
  State<AccountPage> createState() => _AccountPageState();


}

class _AccountPageState extends State<AccountPage> {
  @override
  Future fetchUserInfo() async {
    // Validate returns true if the form is valid, or false otherwise.
    var res = await http.get(Uri.parse(API.userSession),); //passing value to result

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(res.body);

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: CustomAppBar(title: 'Account', imagePath: 'assets/logo/enyecontrols.png',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Center(
            child: (Text(
              "Account Page",
              style: TextStyle(
                fontSize: 40,
                color: Colors.grey
              ),
            )),
          ),
        ),

        /*FutureBuilder(
          future: fetchUserInfo(),
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                ? ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index){
                    List list = snapshot.data;
                    return Row(
                      children: [
                        Text(list[index]['id']),
                        Text(list[index]['fullname']),
                        Text(list[index]['email']),
                      ],
                    );
                  }
              ) : CircularProgressIndicator();
          }
        ),*/
    );
  }
}

