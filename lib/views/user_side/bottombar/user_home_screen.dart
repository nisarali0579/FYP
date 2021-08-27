import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/main_drawer_screen.dart';


class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  TextEditingController msjController = TextEditingController();
  File _galleryImage, _camerImage;
  final picker = ImagePicker();
  List<String> imageList = [];
  String imgUrl;
  bool loading = false;

  Future getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _galleryImage = File(pickedFile.path);
        print(_galleryImage.path);
        imageList.add(_galleryImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _camerImage = File(pickedFile.path);
        print(_camerImage.path);
        imageList.add(_camerImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  sendData() async{

    if(_galleryImage != null){

      setState(() {
        loading = true;
      });

      try{
        Reference ref = FirebaseStorage.instance.ref().child(_galleryImage.path);
        await ref.putFile(_galleryImage);
        imgUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection("notificationRequests").add({
          "msj": msjController.text.trim(),
          "img": imgUrl.toString()
        });

        setState(() {
          loading = false;
        });
        Toast.show("Notification Sent Successfully", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      }catch(e){
        setState(() {
          loading = false;
        });
        Toast.show("Failed to Send Notification", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e.toString());
      }

    }
    else if(_camerImage != null) {
      setState(() {
        loading = true;
      });
      try{
        Reference ref = FirebaseStorage.instance.ref().child(_camerImage.path);
        await ref.putFile(_camerImage);
        imgUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection("notificationRequests").add({
          "msj": msjController.text.trim(),
          "img": imgUrl.toString()
        });
        setState(() {
          loading = false;
        });
        Toast.show("Notification Sent Successfully", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }catch(e){
        setState(() {
          loading = false;
        });
        Toast.show("Failed to Send Notification", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e.toString());
      }

    }
    else{
      Toast.show("Add Image from Camera or Gallery", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print("No image");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Campus Emergency Service ",
          style: GoogleFonts.openSans(
            textStyle: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: .5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: msjController,
                maxLines: 5,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.mainColor, width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.mainColor, width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Your Message here... ',
                  hintStyle: TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.text,
              ),
            ),

            SizedBox(
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => getGalleryImage(),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.mainColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.1,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _galleryImage != null ? Image.file(_galleryImage, height: 70, width: 70,)
                              : Icon(Icons.image, color: Colors.white, size: 60),
                          Text("Gallery", style: TextStyle(color: Colors.white, fontSize: 14),)
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "OR",
                    style: TextStyle(fontSize: 16, color: AppColors.mainColor),
                  ),
                  InkWell(
                    onTap: () => getCameraImage(),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.mainColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.1,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _camerImage != null ? Image.file(_camerImage, height: 70, width: 70,)
                              : Icon(Icons.camera, color: Colors.white, size: 60),
                          Text("Camera", style: TextStyle(color: Colors.white, fontSize: 14),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 65,
            ),


            InkWell(
              onTap: () {
                if(msjController.text.isEmpty){
                  Toast.show("Add Message", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }else{
                  sendData();
                }
              },
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                    child: loading ? CircularProgressIndicator():
                    Text("Notify Admin",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: .5),
                  ),
                )),
              ),
            ),

            SizedBox(
              height: 35,
            ),

            InkWell(
              onTap: () {
                _callNumber("03463480361");
              },
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: AppColors.mainColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/call.png",
                        height: 70,
                        width: 80,
                      ),
                      Text(
                        "CALL ADMIN",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: .5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 35,
            ),

          ],
        ),
      ),
      drawer: MainDrawerScreen(),
    );
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

}

