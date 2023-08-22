import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/config.dart';
import '../../../screens.dart';

class UsertaskTile extends StatelessWidget {
  final UsersInfo users;
  final String departments;
  final String position;
  const UsertaskTile({super.key, required this.users, required this.departments, required this.position});

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

                  //name of user
                  Text(users.name,
                      style: GoogleFonts.lalezar(
                        textStyle:
                        TextStyle(fontSize: 19, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                      )
                  ),

                  //department
                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children: <TextSpan>
                    [
                      TextSpan(text: 'Department : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 14, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: departments,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 15, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),

                  //positions
                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children:
                    [
                      TextSpan(text: 'Postition : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 14, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: position,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 15, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),

                  //email
                  const SizedBox(height: 5.0,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(children: <TextSpan>
                    [
                      TextSpan(text: 'Email : ',
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 14, letterSpacing: 0.8, color: Colors.grey),)
                      ),
                      TextSpan(text: users.email,
                          style: GoogleFonts.lato(
                            textStyle:
                            const TextStyle(fontSize: 15, letterSpacing: 0.8, fontWeight: FontWeight.bold, color: Colors.grey),)
                      ),
                    ]
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.13,
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: users.image.isNotEmpty == true && users.image != ""
                      ? Image.network(API.usersImages + users.image).image
                      : const AssetImage("assets/icons/user.png"),
                ),
              ),
            ),

            const SizedBox(width: 10,),
            users.status == ""
             ? RotatedBox(
              quarterTurns: 3,
              child: Text(
                "CHANGE STATUS",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
            )
             : RotatedBox(
              quarterTurns: 3,
              child: Text(
                users.status.toUpperCase(),
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(users.status)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == "Employee") {
      return Colors.amber;
    } else if (status == "Admin") {
      return Colors.blue;
    } else if (status == "Assistant") {
      return Colors.purple;
    } else if (status == "Manager") {
      return Colors.redAccent;
    } else {
      return Colors.black;
    }
  }
}
