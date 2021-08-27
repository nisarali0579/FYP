0import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/profile_screen.dart';
import 'package:uetemergencyservice/views/user_side/login_screen.dart';


class MainDrawerScreen extends StatefulWidget {
  @override
  _MainDrawerScreenState createState() => _MainDrawerScreenState();
}

class _MainDrawerScreenState extends State<MainDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: AppColors.mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 25,
              ),
              Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 130,
                  width: 130,
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Center(
                child: Text("UET EMERGENCY SERVICE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: .5),
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.white, thickness: 2.5,),
              ),

              SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [

                      Icon(Icons.home, size: 30, color: Colors.white,),

                      SizedBox(width: 20,),

                      Text("Home",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: .5),
                        ),),

                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
                  },
                  child: Row(
                    children: [

                      Icon(Icons.person, size: 30, color: Colors.white,),

                      SizedBox(width: 20,),

                      Text("Profile",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: .5),
                        ),),

                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

//              Padding(
//                padding: const EdgeInsets.only(left: 30),
//                child: InkWell(
//                  onTap: () {
//                    Navigator.of(context).pop();
//                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NotificationScreen()));
//                  },
//                  child: Row(
//                    children: [
//
//                      Icon(Icons.notifications, size: 30, color: Colors.white,),
//
//                      SizedBox(width: 20,),
//
//                      Text("Notifications",
//                        style: GoogleFonts.openSans(
//                          textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: .5),
//                        ),),
//
//                    ],
//                  ),
//                ),
//              ),
//
//              SizedBox(
//                height: 20,
//              ),


              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: InkWell(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    FirebaseAuth.instance.signOut();
                    prefs.clear();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (con) => LoginScreen()), (Route<dynamic> route) => false,);
                  },
                  child: Row(
                    children: [

                      Icon(Icons.logout, size: 30, color: Colors.white,),

                      SizedBox(width: 20,),

                      Text("Logout",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: .5),
                        ),),

                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
