import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

class QuotationPage extends StatefulWidget {
  static const String routeName = '/quotation';

  const QuotationPage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const QuotationPage()
    );
  }

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  late TextEditingController searchTransaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Quotation', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Column(
        children: [
          NormalTextField(controller: searchTransaction, hintText: "Transaction #"),

          Expanded(
            child: ListView(
              children: [

              ],
            ),
          )
        ],
      ),
    );
  }
}

