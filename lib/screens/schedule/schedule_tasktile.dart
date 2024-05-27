import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class ScheduleTaskTile extends StatelessWidget {
  final TSISData tsis;
  final EventsData event;
  ScheduleTaskTile({super.key, required this.tsis, required this.event});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getStatusColor(event.ecColor),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${tsis.tsisNo}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: fontSmallSize,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                Text(
                  event.title,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: fontSmallSize,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),

                Text(
                  "\t - ${tsis.problem}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: fontSmallSize,
                      letterSpacing: 0.5,
                      color: Colors.white),
                  ),
                ),

                const SizedBox(height: 12,),
                Text(
                  "Requestor : ",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: fontSmallSize,
                      letterSpacing: 0.5,
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
                          text: '\t ${tsis.contactPerson} | ${tsis.clientName} | ${tsis.contactNumber}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: fontSmallSize,
                              letterSpacing: 0.5,
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
                      size: fontNormalSize * 1.5,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat.yMMMd().format(DateTime.parse(event.start))} TO ${DateFormat.yMMMd().format(DateTime.parse(event.end))}',
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: fontSmallSize, letterSpacing: 0.5, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              tsis.status.toUpperCase(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: fontSmallSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Color _getStatusColor(String? color) {
    if (color == "#ff8c00") {
      return Colors.orangeAccent;
    } else if (color == "Unread") {
      return Colors.blue;
    } else if (color == "#43A047") {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
  }
}
