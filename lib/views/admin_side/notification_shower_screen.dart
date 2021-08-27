import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uetemergencyservice/utils/colors.dart';


class NotificationShowerScreen extends StatefulWidget {
  String image, text;
  NotificationShowerScreen({this.image, this.text});
  @override
  _NotificationShowerScreenState createState() => _NotificationShowerScreenState();
}

class _NotificationShowerScreenState extends State<NotificationShowerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Notifications ", style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.white, fontSize: 14,letterSpacing: .5),),),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Image.network(widget.image),

              SizedBox(height: 20,),

              Text("Notification Description", style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 18),),

              SizedBox(height: 10,),

              Text(widget.text, style: GoogleFonts.openSans(textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16,letterSpacing: .5),), ),

            ],
          ),
        ),
      ),
    );
  }
}
