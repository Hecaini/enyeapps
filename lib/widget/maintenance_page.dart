import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade200,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.1,
          left: MediaQuery.of(context).size.width * 0.08,
          right: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Lottie.network(
              'https://lottie.host/b2084627-589f-4a5d-b652-cb214c18052c/NiBN8sccYy.json',
              frameRate: FrameRate.max,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.84
            ),

            Column(
              children: [
                Text(
                  "We are Under Maintenance.",
                  style: GoogleFonts.paytoneOne(
                    textStyle: TextStyle(
                        fontSize: 24,
                        letterSpacing: 1.2,
                        color: Colors.deepOrange.shade800
                    ),
                  )
                ),

                const SizedBox(height: 10,),
                Text(
                  "Sorry for the inconvenience, will be back soon !",
                  style: GoogleFonts.alata(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white
                    ),
                  )
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.18),

            Container(
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo/enyecontrols.png"),
                  fit: BoxFit.fill
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}
