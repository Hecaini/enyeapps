import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens.dart';

class BookingtaskTile extends StatelessWidget {
  final TechnicalData services;
  const BookingtaskTile({super.key, required this.services});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //service id
                  Text(services.svcId,
                      style: GoogleFonts.lalezar(
                        textStyle:
                        TextStyle(fontSize: 16, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                      )
                  ),

                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children: <TextSpan>
                    [
                      TextSpan(text: 'Date Booked : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: services.date_booked,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),

                  //title
                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children: <TextSpan>
                    [
                      TextSpan(text: 'Title : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: services.svcTitle,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),

                  //description
                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children:
                    [
                      TextSpan(text: 'Description : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: services.svcDesc,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),

                  //project company side
                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children:
                    [
                      TextSpan(text: 'Project : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: '${services.clientProjName} || ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                      TextSpan(text: services.clientLocation,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),

                  //contacts company side
                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children: <TextSpan>
                    [
                      TextSpan(text: 'Contacts : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: '${services.clientName} || ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),

                      TextSpan(text: '${services.clientContact} || ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),

                      TextSpan(text: services.clientEmail,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10,),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                services.clientCompany.toUpperCase(),
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(services.status)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == "Unread") {
      return Colors.amber;
    } else if (status == "Set-sched") {
      return Colors.blue;
    } else if (status == "Re-sched") {
      return Colors.redAccent;
    } else {
      return Colors.black;
    }
  }
}
