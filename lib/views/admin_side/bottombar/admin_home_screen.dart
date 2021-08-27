import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/admin_side/admin_drawer_screen.dart';
import 'package:uetemergencyservice/views/main_drawer_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:share/share.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  TextEditingController msjController = TextEditingController();
  File _galleryImage, _camerImage;
  final picker = ImagePicker();
  String _platformVersion = 'Unknown';
  List<String> imageList = [];
  bool loading = false;
  String imgUrl;
  TwilioFlutter twilioFlutter;
  List<String> emails = [];

  Future getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _galleryImage = File(pickedFile.path);
        print(_galleryImage.path);
        imageList = [];
        imageList.add(_galleryImage.path);
        print(imageList);
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
        imageList = [];
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

        await FirebaseFirestore.instance.collection("notifications").add({
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

        await FirebaseFirestore.instance.collection("notifications").add({
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
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC2c0737cf7553d34b4450dd668a9adf96',
        authToken: '57b30153dfaed3dcb75f231e10e562ca',
        twilioNumber: '+13342922687');

    getAllEmails();

    super.initState();
  }


  void getAllEmails() async{
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) => {
      emails.add(data['email']),
    });
    print(emails.length);
  }

  void sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: '+923463480361',
        messageBody: msjController.text);
  }

  void sendWhatsapp() async {
    twilioFlutter.sendWhatsApp(
        toNumber: '+923463480361',
        messageBody: msjController.text);
  }

  void sendEmail(String body, String subject, List<String> recievers) async{
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: recievers,
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
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
            textStyle:
            TextStyle(color: Colors.white, fontSize: 14, letterSpacing: .5),
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
              height: 25,
            ),
            InkWell(
              onTap: () {
                if(msjController.text.isEmpty){
                  Toast.show("Add Message", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }else{
                  sendData();
                  sendSms();
                  sendWhatsapp();
                  sendEmail(msjController.text, "Campus Emergency Service", emails);
                }
              },
              child: Container(
                height: 60,
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
                    Text(
                      "Notify Users ",
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
              height: 45,
            ),


            SizedBox(
              height: 45,
            ),

            InkWell(
              onTap: () {
                if(msjController.text.isEmpty){
                  Toast.show("Add Message", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }else{
                  if(_galleryImage != null || _camerImage != null){
                    Share.shareFiles(imageList, text: msjController.text);
                  }else{
                    Share.share(msjController.text);
//                    Toast.show("Add Image from Camera or Gallery", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }

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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.mainColor,
                          ),
                          child: Icon(Icons.share, size: 35, color: Colors.white,),
                      ),
                      SizedBox(width: 20,),

                      Text(
                        "SOCIAL APPS",
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
      drawer: AdminDrawerScreen(),
    );
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

}

