import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../../../config/config.dart';
import '../../screens.dart';

Future<Uint8List> pdfBuilderECSO(SOData serviceOrder, TSISData tsis, String serviceBySign) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/logo/enyecontrols.png')).buffer.asUint8List());
  final imgGoods = MemoryImage(
      (await rootBundle.load('assets/icons/check-mark.png')).buffer.asUint8List());
  final imgReplace = MemoryImage(
      (await rootBundle.load('assets/icons/exclamation.png')).buffer.asUint8List());
  final imgTesting = MemoryImage(
      (await rootBundle.load('assets/icons/clipboard.png')).buffer.asUint8List());

  final imgConSign = await loadSignatureImage(API.ec_conformeSig, serviceOrder.conformeSignature);
  final imgUserSign = await loadSignatureImage(API.ec_usersSig, serviceBySign);

  pdf.addPage(
    MultiPage(
      pageTheme: PageTheme(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      ),
      header: (context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    imageLogo,
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.contain,
                    width: 200,
                    height: 180,
                  ),
                  SizedBox(height: 5),
                  smallText("G/F LOFICE I Business Center"),
                  smallText("#82 Sct. Ojeda St., Brgy. Obrero,"),
                  smallText("Diliman Quezon City"),
                  smallText("Tel No. (02) 410-8841 / 352-3250 Loc. 610, 611 & 612 ;"),
                  smallText("Fax No. Loc. 614 & 613"),
                  smallText("www.enyecontrols.com"),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 130,
                    child: Text(
                        "WORK ORDER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            font: Font.helveticaBold(),
                            fontWeight: FontWeight.bold,
                            color: PdfColor.fromHex("#808080")
                        )
                    ),
                  ),
                  SizedBox(height: 5),
                  tableWorkOrderRight('SERVICE ORDER #', serviceOrder.soNo),
                  SizedBox(height: 10), // Adds spacing between tables
                  tableWorkOrderRight('DATE', serviceOrder.dateSO),
                ],
              ),
            ],
          ),

          Container(height: 20),
        ]
      ),
      build: (context) => [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 260,
                    color: PdfColor.fromHex("#E5E4E2"),
                    child: tableTextBody("WORK DETAILS")
                ),
                Table(
                    columnWidths: {
                      0: FixedColumnWidth(90),
                      1: FixedColumnWidth(10),
                      2: FixedColumnWidth(160),
                    },
                    children: [
                      TableRow(
                        children: [
                          tableTextTitleStart("Time In"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(serviceOrder.timeIn),
                        ],
                      ),
                      TableRow(
                        children: [
                          tableTextTitleStart("Time Out"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(serviceOrder.timeOut)
                        ],
                      ),
                      TableRow(
                        children: [
                          tableTextTitleStart("System / Product"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(serviceOrder.systemProduct),
                        ],
                      ),
                      TableRow(
                        children: [
                          tableTextTitleStart("Location"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(serviceOrder.location),
                        ],
                      ),
                      TableRow(
                        children: [
                          tableTextTitleStart("Complaint"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(serviceOrder.complaint),
                        ],
                      ),
                    ]
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 195,
                    color: PdfColor.fromHex("#E5E4E2"),
                    child: tableTextBody("CLIENT")
                ),
                Table(
                    columnWidths: {
                      0: FixedColumnWidth(50),
                      1: FixedColumnWidth(10),
                      2: FixedColumnWidth(135),
                    },
                    children: [
                      TableRow(
                        children: [
                          tableTextTitleStart("TSIS#"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(tsis.tsisNo),
                        ],
                      ),
                      TableRow(
                        children: [
                          tableTextTitleStart("Project"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(tsis.project)
                        ],
                      ),
                      TableRow(
                        children: [
                          tableTextTitleStart("Address"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(tsis.location),
                        ],
                      ),
                      TableRow(
                        children: [
                          tableTextTitleStart("Client"),
                          tableTextTitleStart(":"),
                          tableTextBodyStart(tsis.clientName + tsis.contactPerson),
                        ],
                      )
                    ]
                ),
              ],
            ),
          ],
        ),
        ListView(
          children: [
            Container(height: 20),
            tableBody('STATUS', serviceOrder.status),

            Container(height: 20),
            tableBody('REMARKS / RECOMMENDATION', serviceOrder.remark),
          ]
        ),

        Container(height: 20),
        if (serviceOrder.service == "Parts need to be Replaced")
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: PdfColors.redAccent, width: 2)), // Underline
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          imgReplace,
                          height: 15,
                          width: 15,
                        ),
                        Container(width: 10),
                        Text(
                            serviceOrder.service,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: PdfColor.fromHex("#28282B"),
                            )
                        ),
                      ]
                  )
              )
          )
        else if (serviceOrder.service == "For Further Testing")
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: PdfColors.orangeAccent, width: 2)), // Underline
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          imgTesting,
                          height: 15,
                          width: 15,
                        ),
                        Container(width: 10),
                        Text(
                            serviceOrder.service,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: PdfColor.fromHex("#28282B"),
                            )
                        ),
                      ]
                  )
              )
          )
        else
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: PdfColors.green, width: 2)), // Underline
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          imgGoods,
                          height: 15,
                          width: 15,
                        ),
                        Container(width: 10),
                        Text(
                            serviceOrder.service,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: PdfColor.fromHex("#28282B"),
                            )
                        ),
                      ]
                  )
              )
          ),

        Container(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tableTextTitleStart("Conforme : "),

                if (imgConSign != null)
                  Container(
                      width: 200,
                      height: 30,
                      alignment: Alignment.center,
                      child: Image(imgConSign, height: 50, width: 50, fit: BoxFit.fill)
                  )
                else
                  Container(
                    width: 200,
                    height: 30,
                    alignment: Alignment.center,
                  ),

                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: PdfColors.black, width: 1)), // Underline
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 5),
                    child: Text(
                        serviceOrder.conforme.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: PdfColor.fromHex("#28282B"),
                        )
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                      "(Signature Over Printed Name / Position)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8.5,
                        fontStyle: FontStyle.italic,
                        color: PdfColor.fromHex("#28282B"),
                      )
                  ),
                )
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tableTextTitleStart("Service by : "),
                if (imgUserSign != null)
                  Container(
                      width: 200,
                      height: 30,
                      alignment: Alignment.center,
                      child: Image(imgUserSign, height: 50, width: 50, fit: BoxFit.fill)
                  )
                else
                  Container(
                    width: 200,
                    height: 30,
                    alignment: Alignment.center,
                  ),

                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: PdfColors.black, width: 1)), // Underline
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 5),
                    child: Text(
                        serviceOrder.servicedBy.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: PdfColor.fromHex("#28282B"),
                        )
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                      "(Signature Over Printed Name)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8.5,
                        fontStyle: FontStyle.italic,
                        color: PdfColor.fromHex("#28282B"),
                      )
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    ),

  );
  return pdf.save();
}