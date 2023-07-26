import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../widget/widgets.dart';
import '../screens.dart';

class TechSchedPage extends StatefulWidget {
  static const String routeName = '/quotation';

  const TechSchedPage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const TechSchedPage()
    );
  }

  @override
  State<TechSchedPage> createState() => _TechSchedPageState();
}

class _TechSchedPageState extends State<TechSchedPage> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController? searchTransaction;

  int _currentExpandedTileIndex = -1;


  //below this are for technical datas get to server
  List<TechnicalData>? _services;

  _getCategories(){
    TechnicalDataServices.getTechnicalData().then((TechnicalData){
      setState(() {
        _services = TechnicalData;
      });
      print("Length ${TechnicalData.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Technical Schedule', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          
          Expanded(
            child: Container(),
          ),
          
          //first trial
          /*NormalTextField(controller: searchTransaction, hintText: "Service #"),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: 20,
              itemBuilder: (context, index){
                return Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: ExpansionTile(
                    collapsedShape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3),)),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.deepOrange),
                      borderRadius: BorderRadius.circular(3)),
                    key: Key(_currentExpandedTileIndex.toString()),
                    initiallyExpanded: index == _currentExpandedTileIndex,
                    onExpansionChanged: ((newState) {
                      if (newState) {
                        setState(() {
                          _currentExpandedTileIndex = index;
                        });
                      } else {
                        setState(() {
                          _currentExpandedTileIndex = -1;
                        });
                      }
                    }),
                    title: RichText(
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      text: const TextSpan(children: <TextSpan>
                        [
                          TextSpan(text: 'Service # |',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: "Company Name | ",
                            style: TextStyle(fontSize: 15, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: "Concern",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ]
                      ),
                    ),

                  ),
                );
              }
            ),
          )*/
        ],
      ),
    );
  }

  _addTaskBar (){
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )
                    )
                ),
                Text("Today",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        )
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  _addDateBar () {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.deepOrange,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }
}

