import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/user_home.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/user_home_screen.dart';
import 'package:uetemergencyservice/views/user_side/signup_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisibleOne = false;
  bool loading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [

          SizedBox(
            height: 50,
          ),
          Center(
            child: Image.asset(
              "assets/logo.png",
              height: 100,
              width: 130,
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Center(
            child: Text("WELCOME BACK TO\n CAMPUS EMERGENCY SERVICE",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: .5),
              ),
            ),
          ),

          SizedBox(
            height: 80,
          ),

          Form(
            key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Email",
                      style: GoogleFonts.openSans( textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16,),),

                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'nisar@gmail.com',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.mainColor,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Password",
                      style: GoogleFonts.openSans( textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16,),),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      obscureText: !_passwordVisibleOne,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: '************',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.mainColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisibleOne
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.mainColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisibleOne = !_passwordVisibleOne;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            "Forgot Password ?",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: AppColors.mainColor, fontSize: 12, letterSpacing: .5),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                  SizedBox(
                    height: 50,
                  ),


                  Center(
                    child: InkWell(
                      onTap: () async{

                        if (_formKey.currentState.validate()) {
                          if (isEmail(emailController.text)) {

                            _signInWithEmailAndPassword();

                          }else{
                            Toast.show("Invalid Email", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            setState(() {
                              loading = false;
                            });
                          }

                        } else {
                          Toast.show("Ivalid Form data", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          setState(() {
                            loading = false;
                          });
                        }

                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),

                        child: Center(
                          child: loading
                              ? CircularProgressIndicator()
                              : Text("Login",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: .5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                        },
                        child: Text(
                          "Don't have an Account? Sign up",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(color: AppColors.mainColor, fontSize: 12, letterSpacing: .5),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],

              )
          ),

        ],
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  _signInWithEmailAndPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    try{
      final User user = (await _firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text.toString().trim(), password: passwordController.text.toString().trim())).user;

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((userData) {

        setState(() {
          prefs.setString("id", userData.data()['id']);
          prefs.setString("name", userData.data()['name']);
          prefs.setString("email", userData.data()['email']);
          prefs.setString("phone", userData.data()['phone']);
          prefs.setString("password", userData.data()['password']);
          prefs.setString("registeration", userData.data()['registeration']);

        });
      });

        setState(() {
          loading = false;
        });
      Toast.show("Logged in Successfully", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome()),);

    }catch(e){
      setState(() {
        loading = false;
      });
      print(e.toString());
    }
  }
}
