import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/admin_side/bottombar/admin_home.dart';


class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisibleOne = false;
  bool loading = false;

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
            child: Text("WELCOME BACK TO\nUET EMERGENCY SERVICE",
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
                        hintText: 'admin@gmail.com',
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoginScreen()));
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

                            if(emailController.text == "admin@gmail.com" && passwordController.text == "admin123") {

                              setState(() {
                                loading = true;
                              });

                              try{
                                UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                                User user = result.user;
                                if (user != null) {

                                  setState(() {
                                    loading = false;
                                  });

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));

                                } else {
                                  Toast.show("failed to login", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  setState(() {
                                    loading = false;
                                  });
                                }

                              }catch(e){
                                if (e.code == 'user-not-found') {
                                  Toast.show("No user exists with this email", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  setState(() {
                                    loading = false;
                                  });
                                } else if (e.code == 'wrong-password') {
                                  Toast.show("Invalid Password", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              }

                            }else{
                              Toast.show("You are not admin", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            }

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
}
