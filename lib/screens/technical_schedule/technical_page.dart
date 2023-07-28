import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  void initState(){
    super.initState();
    _services = [];
    _getServices();

    _account = [];
    _getAccounts();
  }


  //below this are for technical datas get to server
  late List<TechnicalData> _services;
  _getServices(){
    TechnicalDataServices.getTechnicalData().then((technicalData){
      setState(() {
        _services = technicalData;
      });
      print("Length ${technicalData.length}");
    });
  }

  //below this are for account infos get to server
  late List<AccountInfo> _account;
  _getAccounts(){
    AccountInfoServices.getAccountInfo().then((accountInfo){
      setState(() {
        _account = accountInfo;
      });
      print("Length ${accountInfo.length}");
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

          SizedBox(height: 10,),
          
          Expanded(
            child: ListView.builder(
              itemCount: _services.length,
              itemBuilder: (_, index){
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSheet(_services[index]);
                            },
                            child: TaskTile(services: _services[index]),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
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

  _showBottomSheet (TechnicalData services) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: services.status == "On Process" || services.status == "Unread" ?
            MediaQuery.of(context).size.height * 0.34 :
            MediaQuery.of(context).size.height * 0.24,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]
                ),
              ),

              Spacer(),
              Container(),

              services.status == "Unread" ?
              _bottomSheetButton(
                label: "Acknowledge",
                onTap: (){
                  setState(() {
                    _showAnotherBottomSheet(services);
                  });
                },
                clr: Colors.blue,
                context:context,
              ): Container(),

              services.status == "On Process" ?
              _bottomSheetButton(
                label: "Task Completed",
                onTap: (){
                  Navigator.pop(context);
                },
                clr: Colors.green,
                context:context,
              ): Container(),

              SizedBox(height: 10,),
              _bottomSheetButton(
                label: "View",
                onTap: (){

                },
                clr: Colors.orangeAccent,
                context:context,
              ),

              SizedBox(height: 20,),
              _bottomSheetButton(
                label: "Close",
                onTap: (){
                  Navigator.pop(context);
                },
                clr: Colors.orangeAccent,
                context:context,
                isClose: true,
              ),

              SizedBox(height: 10,),
            ],
          ),
        );
      }
    );
  }

  String? valueChooseAccount;
  _showAnotherBottomSheet (TechnicalData services) {
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return MasonryGridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            children: <Widget> [
              Container(
                height: 6,
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4, right: MediaQuery.of(context).size.width * 0.4, top: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]
                ),
              ),

              const SizedBox(height: 30,),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Title :"),
                        RichText(
                          softWrap: true,
                          text: TextSpan(text: services.svcTitle,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              DateFormat.jm().format(DateTime.parse(services!.dateSched + " " + services!.timeSched)),
                              style: GoogleFonts.lato(
                                textStyle:
                                TextStyle(fontSize: 15,),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              DateFormat.yMMMd().format(DateTime.parse(services!.dateSched + " " + services!.timeSched)),
                              style: GoogleFonts.lato(
                                textStyle:
                                TextStyle(fontSize: 15,),
                              ),
                            ),
                          ],
                        ),

                        Text("Description :"),
                        RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text: TextSpan(text: services.svcDesc,
                            style: TextStyle(color: Colors.black),),
                        ),
                        //Text(services.svcDesc, maxLines: 5, softWrap: false,),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      children: [
                        Text("Client Name :"),
                        RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text: TextSpan(text: services.clientName,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ),

                        Text("Company :"),
                        RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text: TextSpan(text: services.clientCompany,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ),
                        Text("Location :"),
                        RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text: TextSpan(text: services.clientLocation,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ),
                        Text("Project Name :"),
                        RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text: TextSpan(text: services.clientProjName,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ),
                        Text("Contact :"),
                        RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text: TextSpan(text: services.clientContact,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ),
                        Text("Email :"),
                        RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text: TextSpan(text: services.clientEmail,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10,),

              //drop-down button
              StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton(
                      alignment: Alignment.bottomCenter,
                      underline:Container(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                      isDense: true,
                      iconSize: 36,
                      iconEnabledColor: Colors.deepOrange,
                      isExpanded: true,
                      value: valueChooseAccount,
                      onChanged: (value){
                        setState(() {
                          valueChooseAccount = value;
                        });
                        print(valueChooseAccount);
                      },
                      hint: Text("Select Person In Charge"),
                      items: _account.map((accountInfo) => DropdownMenuItem(
                        alignment: Alignment.bottomCenter,
                        value: accountInfo.user_id.toString(),
                        child: Text("${accountInfo.name.toString()} || ${accountInfo.position.toString()}", textAlign: TextAlign.center,),
                      )).toList(),
                    ),
                  );
                }
              ),

              const SizedBox(height: 20,),
              _bottomSheetButton(
                label: "Close",
                onTap: (){
                  valueChooseAccount = null;
                  Navigator.pop(context);
                },
                clr: Colors.orangeAccent,
                context:context,
                isClose: true,
              ),

              SizedBox(height: 10,),
            ],
          );
        }
    ).whenComplete(() => valueChooseAccount = null);
  }

  _bottomSheetButton ({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: isClose == true ? Colors.grey.shade300 : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold) : TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
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

