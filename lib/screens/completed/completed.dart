
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../widget/widgets.dart';
import '../screens.dart';

class CompletedPage extends StatefulWidget {
  static const String routeName = '/completed';

  const CompletedPage({super.key});


  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const CompletedPage()
    );
  }

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  bool? userSessionFuture;
  final searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _services = [];
    _getServices();

    //calling session data
    /*checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          ClientInfo = value;
          _getServices();
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });*/
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
    TechnicalDataServices.getTechnicalData().then((technicalData){
      setState(() {
        _services = technicalData.where((element) => element.status == "Completed" || element.status == "Cancelled").toList();
      });
    });
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

