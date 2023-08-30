
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widget/widgets.dart';
import '../../config/config.dart';
import '../screens.dart';

// ignore: must_be_immutable
class CompletedPage extends StatefulWidget {
  static const String routeName = '/completed';

  RemoteMessage? message;

  CompletedPage({super.key, required this.message});


  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => CompletedPage(message: message,)
    );
  }

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final searchController = TextEditingController();

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  @override
  void initState(){
    super.initState();
    _services = [];
    _users = [];
    _position = [];
    _getAccounts();
    _getPositions();

    //calling session data
    CheckSessionData().getUserSessionStatus().then((session) {
      if (session == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
          _getServices();
        });
        userSessionFuture = session;
      } else {
        userSessionFuture = session;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }

  late List<TechnicalData> _services;

  _getServices(){
    if(userInfo?.status == "Employee") {
      TechnicalDataServices.getTechnicalData().then((technicalData){
        setState(() {
          _services = technicalData.where((element) => element.status == "Completed" && element.svcHandler == userInfo?.userId).toList();
        });
      });
    } else {
      TechnicalDataServices.getTechnicalData().then((technicalData){
        setState(() {
          _services = technicalData.where((element) => element.status == "Completed" || element.status == "Cancelled").toList();
        });
      });
    }
  }

  List<TechnicalData> _filteredServices = [];
  void filterSystemsList() {
    _filteredServices = _services.where((technicalData) {
      final svcId = technicalData.svcId.toLowerCase();
      final searchQuery = searchController.text.toLowerCase();
      return svcId.contains(searchQuery);
    }).toList();
  }

  late List<Position> _position;
  _getPositions(){
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
    });
  }

  //below this are for account infos get to server
  late List<UsersInfo> _users;
  _getAccounts(){
    UsersInfoServices.getUsersInfo().then((accountInfo){
      setState(() {
        _users = accountInfo;
      });
    });
  }

  //this code is for tile if open, other closes
  int _currentExpandedTileIndex = -1;

  @override
  Widget build(BuildContext context) {
    if(widget.message!.data["goToPage"] == "Completed"){
      searchController.text = '${widget.message!.data["code"]}';
      filterSystemsList();
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'History', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search SERVICE #',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    FocusScope.of(context).unfocus();
                    filterSystemsList();
                  },
                  icon: const Icon(Icons.clear),
                )
                    : null, // Set suffixIcon to null when text is empty
              ),
              onChanged: (value) {
                setState(() {
                  filterSystemsList();
                  if(searchController.text.isEmpty){
                    FocusScope.of(context).unfocus();
                  }
                });
              },
              onEditingComplete: () {
                filterSystemsList();
              },
            ),
          ),

          const SizedBox(height: 25,),
          _services.isEmpty
            ? const Expanded(
            child: Center(
              child: (Text(
                "No Data Available",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.grey
                ),
              )),
            ),
          )
            : Expanded(
            child: ListView.builder(
                itemCount: searchController.text.isEmpty ? _services.length : _filteredServices.length,
                itemBuilder: (_, index){
                  _filteredServices = searchController.text.isEmpty ? _services : _filteredServices;

                  return Container(
                    margin: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.deepOrange,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: ExpansionTile(

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
                      title: Text(
                        "#${_filteredServices[index].svcId}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <Widget>[
                        const SizedBox(height: 12,),
                        Text(
                          _filteredServices[index].svcTitle.toUpperCase(),
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),

                        const SizedBox(height: 8,),
                        Text(
                          _filteredServices[index].svcDesc,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54),
                          ),
                        ),

                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.deepOrange,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat.yMMMMd().format(DateTime.parse(_filteredServices[index].dateSched)),
                              style: GoogleFonts.lato(
                                textStyle:
                                const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Text(
                          "CLIENT INFORMATION :",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          textAlign: TextAlign.center,
                          softWrap: true,
                          text: TextSpan(children: <TextSpan>
                          [
                            TextSpan(text: "${_filteredServices[index].clientName} || ",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: "${_filteredServices[index].clientCompany} || ",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: "${_filteredServices[index].clientContact} || ",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: _filteredServices[index].clientEmail,
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                          ]
                          ),
                        ),

                        const SizedBox(height: 12),
                        RichText(
                          softWrap: true,
                          text: TextSpan(children: <TextSpan>
                          [
                            TextSpan(text: "Notes by Handler : ",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: _filteredServices[index].notesComplete,
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                          ]
                          ),
                        ),

                        const SizedBox(height: 12),
                        RichText(
                          softWrap: true,
                          text: TextSpan(children: <TextSpan>
                          [
                            TextSpan(text: "Handled By : ",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: "\n \t ${_users.where((user) => user.user_id == _filteredServices[index].svcHandler).elementAtOrNull(0)?.name}",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: " || ${_position.where((position) => position.id == _users.where((user) => user.user_id == _filteredServices[index].svcHandler).elementAtOrNull(0)?.position).elementAtOrNull(0)?.position}",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                          ]
                          ),
                        ),

                        const SizedBox(height: 12),
                        RichText(
                          softWrap: true,
                          text: TextSpan(children: <TextSpan>
                          [
                            TextSpan(text: "Assigned By : ",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: "\n \t ${_users.where((user) => user.user_id == _filteredServices[index].assignedBy).elementAtOrNull(0)?.name}",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                            TextSpan(text: " || ${_position.where((position) => position.id == _users.where((user) => user.user_id == _filteredServices[index].assignedBy).elementAtOrNull(0)?.position).elementAtOrNull(0)?.position}",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),
                              ),),
                          ]
                          ),
                        ),

                        const SizedBox(height: 12,),
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}

