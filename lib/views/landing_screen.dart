import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/admin_side/admin_login_screen.dart';
import 'package:uetemergencyservice/views/user_side/login_screen.dart';
import 'package:uetemergencyservice/views/user_side/signup_screen.dart';


class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          SizedBox(height: 60,),

          Center(child: Image.asset("assets/logo.png", height: 200, width: 200,)),

          SizedBox(height: 30,),

          Center(
            child: Text("Welcome to \nCampus Emergency Service",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(color: AppColors.mainColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: .5),
              ),
            ),
          ),

          Spacer(),

          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoginScreen()));
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.mainColor,
                 // color: Colors.red,
              ),

              child: Center(
                child: Text("Continue As Admin",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: .5),
                ),
              ),
              ),
            ),
          ),

          SizedBox(height: 40,),

          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.mainColor,
              ),

              child: Center(
                child: Text("Continue As User",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: .5),
                  ),
                ),
              ),
            ),
          ),

          Spacer(),

        ],
      ),
    );
  }
}
