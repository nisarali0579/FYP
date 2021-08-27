import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/main_drawer_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController registerationNoController = TextEditingController();

  bool loading = false;
  bool _status = true;
  final _formKey = GlobalKey<FormState>();
  String user_id, name, email, phone, password ,registerationNo;


  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString("id");
      name = prefs.getString("name");
      email = prefs.getString("email");
      phone = prefs.getString("phone");
      password = prefs.getString("password");
      registerationNo = prefs.getString("registeration");
    });

    nameController.text = name != null ? name != '' ? name : 'Nisar': 'Nisar';
    emailController.text = email != null ? email != '' ? email : 'nisaricup@gmail.com': 'nisaricup@gmail.com';
    phoneController.text = phone != null ? phone != '' ? phone : '03129876345': '03129876345';
    registerationNoController.text = registerationNo != null ? registerationNo != '' ? registerationNo : '17pwbcs0579@uetpeshawar.edu.pk': '17pwbcs0579@uetpeshawar.edu.pk';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Campus Emergency Service ", style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.white, fontSize: 14,letterSpacing: .5),),),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 40,),



            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [

                  Positioned(
                    right: 20,
                    top: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _status ? _getEditIcon() : Container(),
                      ],
                    )
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/logo.png", ),
                    ),
                  ),


                ],
              ),
            ),

            SizedBox(height: 40,),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(fontSize: 12)
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 12)
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(fontSize: 12)
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: registerationNoController,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Registeration No.',
                          labelStyle: TextStyle(fontSize: 12)
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),



                  SizedBox(height: 30,),

//                  InkWell(
//                    onTap: (){
////                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterSuccessScreen()));
//                    },
//                    child: Container(
//                      width: MediaQuery.of(context).size.width * 0.8,
//                      height: 50,
//                      child: Stack(
//                        children: [
//                          Container(
//                            width: MediaQuery.of(context).size.width * 0.8,
//                            height: 50,
//                            alignment: Alignment.bottomRight,
//                            padding: EdgeInsets.symmetric(horizontal: 30.0),
//                            decoration: BoxDecoration(
//                                borderRadius:BorderRadius.circular(30.0),
//                                color: AppColors.mainColor
//                            ),
//                          ),
//                          Center(
//                            child: Text(
//                              "Sign Up",
//                              style: GoogleFonts.lato(
//                                fontSize: 20,
//                                fontWeight: FontWeight.w700,
//                                color: AppColors.whiteColor,
//                              ),
//                            ),
//                          ),
//                          Align(
//                            alignment: Alignment.centerRight,
//                            child: Container(
//                              height: 50,
//                              width: 50,
//                              child: Icon(
//                                Icons.arrow_forward,
//                                color: Colors.white,
//                                size: 30,
//                              ),
//                              decoration: BoxDecoration(
//                                  shape: BoxShape.circle,
//                                  color: Colors.indigoAccent
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
                  !_status ? _getActionButtons() : Container(),

                ],
              ),
            ),

          ],
        ),
      ),

      drawer: MainDrawerScreen(),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: Text("Edit", style: TextStyle(fontSize: 12, color: AppColors.mainColor),),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                    child: Text("Update Profile",
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    textColor: Colors.white,
                    color: AppColors.mainColor,
                    onPressed: () {

                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(FocusNode());

                      });

                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                    child: Text("Cancel",
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });

                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}