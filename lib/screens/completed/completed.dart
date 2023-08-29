
import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../widget/widgets.dart';
import '../../config/config.dart';
import '../screens.dart';

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

    //calling session data
    CheckSessionData().getUserSessionStatus().then((bool) {
      if (bool == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
          _getServices();
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
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
              decoration: const InputDecoration(
                labelText: 'Search SERVICE #',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  filterSystemsList();
                });
              },
              onEditingComplete: (){
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

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                //_showBottomSheet(context, services);
                              },
                              child: TaskTile(services: _filteredServices[index]),
                            )
                          ],
                        ),
                      ),
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

