
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../widget/custom_appbar.dart';
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
  @override

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: CustomAppBar(title: 'Account', imagePath: 'assets/logo/enyecontrols.png',),
        /*drawer: CustomDrawer(),*/
        body: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await SessionManager().destroy();
                  setState(() {
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return loginPage();
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

