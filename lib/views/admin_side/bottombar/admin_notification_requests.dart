import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/admin_side/admin_drawer_screen.dart';
import 'package:uetemergencyservice/views/admin_side/notification_shower_screen.dart';


class AdminNotificationRequestsScreen extends StatefulWidget {
  @override
  _AdminNotificationRequestsScreenState createState() => _AdminNotificationRequestsScreenState();
}

class _AdminNotificationRequestsScreenState extends State<AdminNotificationRequestsScreen> {

  List<String> imageList = [];
  bool loading = false;
  bool load = false;
  TwilioFlutter twilioFlutter;
  List<String> emails = [];


  void sendSms(String msj) async {
    twilioFlutter.sendSMS(
        toNumber: '+923463480361',
        messageBody: msj);
  }

  void sendWhatsapp(String msj) async {
    twilioFlutter.sendWhatsApp(
        toNumber: '+923463480361',
        messageBody: msj);
  }

  void sendEmail(String body, String subject, List<String> recievers) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: recievers,
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  void getAllEmails() async{
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) => {
      emails.add(data['email']),
    });
    print(emails.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllEmails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Notification Requests ", style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.white, fontSize: 14,letterSpacing: .5),),),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("notificationRequests").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return notificationCard(context, index, snapshot.data.docs[index]);
                  });
            }
          },
        ),
      ),

      drawer: AdminDrawerScreen(),
    );
  }

  Widget notificationCard(BuildContext context, int index, QueryDocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationShowerScreen(image: snapshot.data()['img'], text: snapshot.data()['msj']), fullscreenDialog: true));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 2,
                color: Colors.grey,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 10,
                  left: 10,
                  bottom: 10,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(snapshot.data()['img']),
                  )
              ),

              Positioned(
                top: 40,
                bottom: 15,
                left: 120,
                child: Text(
                  snapshot.data()['msj'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white ),
                ),
              ),

              Positioned(
                top: 15,
                right: 15,
                child: InkWell(
                    onTap: () async{
                      setState(() { loading = true; });

                      var collection = FirebaseFirestore.instance.collection('notificationRequests');
                      var snap = await collection.where('msj', isEqualTo: snapshot.data()['msj']).get();
                      for (var doc in snap.docs) {
                        await doc.reference.delete();
                      }

                      setState(() { loading = false; });
                    },
                    child: loading ? CircularProgressIndicator() : Icon(Icons.delete, color: Colors.red, size: 30,)),
              ),

              Positioned(
                bottom: 15,
                right: 15,
                child: InkWell(
                    onTap: () async{
                      setState(() {
                        load = true;
                      });
                      try{
//                        Reference ref = FirebaseStorage.instance.ref().child();
//                        await ref.putFile(_camerImage);
//                        imgUrl = await ref.getDownloadURL();

                        await FirebaseFirestore.instance.collection("notifications").add({
                          "msj": snapshot.data()['msj'],
                          "img": snapshot.data()['img']
                        });
                        var collection = FirebaseFirestore.instance.collection('notificationRequests');
                        var snap = await collection.where('msj', isEqualTo: snapshot.data()['msj']).get();
                        for (var doc in snap.docs) {
                          await doc.reference.delete();
                        }
                        setState(() {
                          load = false;
                        });
                        sendSms(snapshot.data()['msj']);
                        sendWhatsapp(snapshot.data()['msj']);
                        sendEmail(snapshot.data()['msj'], "Campus Emergency Service", emails);
                        Toast.show("Notification Sent Successfully", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }catch(e){
                        setState(() {
                          load = false;
                        });
                        Toast.show("Failed to Send Notification", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        print(e.toString());
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green
                      ),
                      child: load ? CircularProgressIndicator(): Center(child: Text("Approve", style: TextStyle(color: Colors.white),)),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> share(String url, String text) async {
    await FlutterShare.share(
      title: 'Campus Emergency Service',
      text: text,
      linkUrl: url,
    );
  }

}


// 17pwbcs0585@uetpeshawar.edu.pk
// nisaricup@gmail.com
// silentkhan101@gmail.com
// 17pwbcs0570@uetpeshawar.edu.pk