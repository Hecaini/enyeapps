import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class SOPdfPage extends StatefulWidget {
  final String soId;
  const SOPdfPage({Key? key, required this.soId}) : super(key: key);

  @override
  State<SOPdfPage> createState() => _SOPdfPageState();
}

class _SOPdfPageState extends State<SOPdfPage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    _getServiceOrder();
  }

  bool _isLoading = true;
  
  List<SOData> _serviceOrder = [];
  _getServiceOrder(){
    SOServices.getServiceOrder(widget.soId).then((getServiceOrder) {
      setState(() {
        _serviceOrder = getServiceOrder;
        if (_serviceOrder.isNotEmpty) {
          _getAccounts(_serviceOrder[0].servicedBy);
          _getTsis(_serviceOrder[0].tsisId);
        } else {
          // Handle the case where no SO numbers are retrieved.
          _isLoading = false;
          print("No service order numbers retrieved");
        }
      });
    });
  }

  List<EngUsers> _engUsers = [];
  _getAccounts(String servicedBy){
    UsersInfoServices.getEngUsers().then((accountInfo){
      setState(() {
        _engUsers = accountInfo.where((account) => _isUserAssigned(servicedBy, account.username)).toList();
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

  List<TSISData> _tsis = [];
  _getTsis(String tsisId){
    ScheduleDataServices.getTSIS().then((tsis){
      setState(() {
        _tsis = tsis.where((e) => e.tsisId == tsisId).toList();
        _isLoading = false;
      });
    });
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return _isLoading
      ? Center(child: SpinningContainer(controller: _controller),)
      : Scaffold(
          appBar: AppBar(
            title: Text(
              "SO# ${_serviceOrder[0].soNo}",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: fontNormalSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: Colors.white
                ),
              ),
            ),
          ),
          body: InteractiveViewer(
            panEnabled: false,
            boundaryMargin: const EdgeInsets.all(80),
            minScale: 0.5,
            maxScale: 4,
            child: PdfPreview(
              pdfFileName: "SO_${_serviceOrder[0].soNo}-${_tsis[0].project}.pdf",
              loadingWidget: const CupertinoActivityIndicator(),
              build: (context) => pdfBuilderECSO(_serviceOrder[0], _tsis[0], _engUsers[0].signature),
            ),
          ),
        );
  }
}