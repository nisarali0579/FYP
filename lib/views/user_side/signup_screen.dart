import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/user_side/login_screen.dart';


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController registerationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisibleOne = false;
  bool _passwordVisibleTwo = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(

        children: [

          SizedBox(
            height: 20,
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
            child: Text("REGISTERATION",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(color: AppColors.mainColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: .5),
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Form(
            key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Name",
                      style: GoogleFonts.openSans( textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16,),),

                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your first name';
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
                        hintText: 'Nisar',
                        hintStyle: TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.mainColor,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "UET Registeration No.",
                      style: GoogleFonts.openSans( textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16,),),

                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: registerationController,
                      validator: validateRegNo,
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
                        hintText: '17pwbcs0579',
                        hintStyle: TextStyle(fontSize: 12),
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
                      validator: validateEmail,
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
                        hintStyle: TextStyle(fontSize: 12),
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
                      "Phone",
                      style: GoogleFonts.openSans( textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16,),),

                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your phone number';
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
                        hintText: '031398467373',
                        hintStyle: TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: AppColors.mainColor,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
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
                        hintStyle: TextStyle(fontSize: 12),
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Confirm Password",
                      style: GoogleFonts.openSans( textStyle: TextStyle(color: AppColors.mainColor, fontSize: 16,),),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      obscureText: !_passwordVisibleTwo,
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
                        hintStyle: TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.mainColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisibleTwo
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.mainColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisibleTwo = !_passwordVisibleTwo;
                            });
                          },
                        ),
                      ),

                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),


                  Center(
                    child: InkWell(
                      onTap: () async{
                        if(_formKey.currentState.validate()){
                          _formKey.currentState.save();

                          if(passwordController.text == confirmPasswordController.text) {

                            _register();

                          } else{
                            Toast.show("Password Not Matched", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }

                        }else{
                          Toast.show("Invalid Form Data", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
                              : Text("Sign up",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: .5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Already have an Account? Sign in",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(color: AppColors.mainColor, fontSize: 12, letterSpacing: .5),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
          ),

        ],
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validateRegNo(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Registeration No';
    else
      return null;
  }

  void _register() async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmPasswordController.text.trim();
    if(password == confirmpassword) {
      setState(() {
        loading = true;
      });
      try {

        UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email, password: password);

        User user = result.user;
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          "id": user.uid,
          "name": nameController.text,
          "email": emailController.text,
          "registeration": registerationController.text,
          "phone": phoneController.text,
          "password": passwordController.text
        });

        setState(() {
          if (user != null) {
            setState(() {
              loading = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
          }
        });
      } catch (e) {
        setState(() {
          loading = false;
        });
        print(e.toString());
      }
    }
    else{
      setState(() {
        loading = false;
      });
      print("Passwords don't match");
    }
  }
}
