import 'package:enye_app/screens/screens.dart';
import 'package:flutter/material.dart';

import '../widget/custom_navbar.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings){
    print('This is route:${settings.name}');

    switch (settings.name){
      case '/':
        return CustomNavBar.route();
      case DashboardPage.routeName:
        return DashboardPage.route();
      case OrdersPage.routeName:
        return OrdersPage.route();
      case AppointmentPage.routeName:
        return AppointmentPage.route();
      case CatalogsPage.routeName:
        return CatalogsPage.route();
      case AccountPage.routeName:
        return AccountPage.route();

      default: 
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text('Error'),)
        )
    );
  }
}

