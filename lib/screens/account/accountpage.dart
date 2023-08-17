import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/account';

  const AccountPage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const AccountPage()
    );
  }

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<UserLogin>? userInfo;

  @override
  Future <UserLogin> _getUserSessionStatus() async {
    UserLogin userInfo = UserLogin.fromJson(await SessionManager().get("user_data"));

    return userInfo;
  }

  Widget build(BuildContext context) {
    _getUserSessionStatus().then((value) => print(value.name));

    return Scaffold(
        appBar: CustomAppBar(title: 'Account', imagePath: 'assets/logo/enyecontrols.png',),
        /*drawer: CustomDrawer(),*/
        body: Center(
          child: Column(
            children: [
              FutureBuilder<UserLogin>(
                future: _getUserSessionStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the Future is still loading, show a loading indicator or placeholder
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If there's an error in fetching the data, handle the error here
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // If the Future has completed and data is available, display the user information
                    UserLogin userInfo = snapshot.data!;
                    return Text("Username: ${userInfo.username}, Email: ${userInfo.email}");
                  }
                },
              ),


              ElevatedButton.icon(
                onPressed: () async {
                  dynamic token = await SessionManager().get("token");
                  await SessionManager().remove("user_data");
                  //clear the client_id in a token
                  TokenServices.updateToken(token.toString(), "").then((result) {
                    if('success' == result){
                      print("Updated token successfully");
                    } else {
                      print("Error updating token");
                    }
                  });

                  setState(() {
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return LoginPage();
                        },
                      ),
                          (_) => false,
                    );
                  });
                },
                icon: const Icon(
                  Icons.logout,
                  size: 24.0,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ), // <-- Text
              ),
            ],
          ),
        ),
    );
  }
}

