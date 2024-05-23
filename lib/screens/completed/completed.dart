
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
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

class _CompletedPageState extends State<CompletedPage> with TickerProviderStateMixin {
  final searchController = TextEditingController();

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  bool _isLoading = true;
  double? _progress;

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
          _getOnProcessAppointment();
        });
        userSessionFuture = session;
      } else {
        userSessionFuture = session;
      }
    });

    if(widget.message!.data["goToPage"] == "Completed"){
      searchController.text = '${widget.message!.data["code"]}';
    }

    _getServiceOrder();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  late List<TechnicalData> _services;

  _getServices() {
    if(userInfo?.status == "Employee") {
      TechnicalDataServices.getTechnicalData().then((technicalData){
        setState(() {
          _services = technicalData.where((element) => element.status == "Completed" && element.svcHandler == userInfo?.userId).toList();
        });
        _isLoading = false;
      });
    } else {
      TechnicalDataServices.getTechnicalData().then((technicalData){
        setState(() {
          _services = technicalData.where((element) => element.status == "Completed").toList();
        });
        _isLoading = false;
      });
    }
  }

  List<TechnicalData> _filteredServices = [];
  void filterSystemsList() {
    _filteredServices = _services.where((technicalData) {
      final svcId = technicalData.svcId.toLowerCase();
      final clientCompany = technicalData.clientCompany.toLowerCase();
      final service = technicalData.service.toLowerCase();
      final clientProjName = technicalData.clientProjName.toLowerCase();

      final searchQuery = searchController.text.toLowerCase();
      return (svcId.contains(searchQuery) || clientCompany.contains(searchQuery) || service.contains(searchQuery) || clientProjName.contains(searchQuery));
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

  List<AppointmentData> _opAppointment = [];
  _getOnProcessAppointment(){
    AppointmentServices.getAllAppointment().then((Appointment){
      setState(() {
        _opAppointment = Appointment;
      });
    });
  }

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }

    return false;
  }

  List<ServiceOrder> _serviceOrder = [];
  _getServiceOrder(){
    SODataServices.getAllServiceOrder().then((serviceOrder){
      setState(() {
        _serviceOrder = serviceOrder;
      });
    });
  }

  //this code is for tile if open, other closes
  int _currentExpandedTileIndex = -1;

  @override
  Widget build(BuildContext context) {
    if(widget.message!.data["goToPage"] == "Completed"){
      filterSystemsList();
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'History', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: _isLoading
        ? Center(child: SpinningContainer(controller: _controller),)
        : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getServices();
              _getOnProcessAppointment();
              _getAccounts();
              _getPositions();
              _getServiceOrder();
            });
          },
          child: Column(
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

                        AppointmentData? appointment = _opAppointment.where((appointment) => _filteredServices[index].id == appointment.svcId).elementAtOrNull(0);

                        return Container(
                          margin: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _getStatusColor(_filteredServices[index].status),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: ExpansionTile(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7))),
                            textColor: Colors.white,
                            backgroundColor: _getStatusColor(_filteredServices[index].status),
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
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => ViewCompletePage(services: _filteredServices[index], appointment: appointment)),
                                    ).then((value) {
                                      // Refresh the services once the StatusPage is popped
                                      _getServices();
                                      _getOnProcessAppointment();
                                      _getAccounts();
                                      _getPositions();
                                      _getServiceOrder();
                                      setState(() {});
                                    });
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                    //  width: SizeConfig.screenWidth * 0.78,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _filteredServices[index].svcTitle,
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),

                                            const SizedBox(height: 12,),
                                            Text(
                                              "Requestor : ",
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.justify,
                                                softWrap: true,
                                                text:TextSpan(
                                                    children: <TextSpan> [
                                                      TextSpan(
                                                        text: '\t ${_filteredServices[index].reqName} | ${_filteredServices[index].reqPosition}',
                                                        style: GoogleFonts.lato(
                                                          textStyle: const TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                    ]
                                                )
                                            ),

                                            const SizedBox(height: 12,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_rounded,
                                                  color: Colors.grey[200],
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${DateFormat.yMMMd().format(DateTime.parse(appointment!.startDatetime))} TO ${DateFormat.yMMMd().format(DateTime.parse(appointment!.endDatetime))}',
                                                  style: GoogleFonts.lato(
                                                    textStyle:
                                                    TextStyle(fontSize: 13, color: Colors.grey[100]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.access_time_filled_rounded,
                                                  color: Colors.grey[200],
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${DateFormat.jm().format(DateTime.parse(appointment!.startDatetime))} - ${DateFormat.jm().format(DateTime.parse(appointment!.endDatetime))}',
                                                  style: GoogleFonts.lato(
                                                    textStyle:
                                                    TextStyle(fontSize: 13, color: Colors.grey[100]),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 12),
                                            RichText(
                                              softWrap: true,
                                              text: TextSpan(children: <TextSpan>
                                              [
                                                TextSpan(text: "${_filteredServices[index].clientName} || ",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, color: Colors.grey[100], letterSpacing: 0.8),
                                                  ),),
                                                TextSpan(text: "${_filteredServices[index].clientCompany} || ",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                                                  ),),
                                                TextSpan(text: "${_filteredServices[index].clientContact} || ",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                                                  ),),
                                                TextSpan(text: _filteredServices[index].clientEmail,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, color: Colors.grey[100], letterSpacing: 0.8),
                                                  ),),
                                              ]
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        height: 150,
                                        width: 0.5,
                                        color: Colors.grey[200]!.withOpacity(0.7),
                                      ),
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          _filteredServices[index].status.toUpperCase(),
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ),
              ],
    ),
        ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == "On Process") {
      return Colors.orangeAccent;
    } else if (status == "Unread") {
      return Colors.blue;
    } else if (status == "Completed") {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
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
            style: isClose ? const TextStyle(color: Colors.black, fontWeight: FontWeight.bold) : const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

