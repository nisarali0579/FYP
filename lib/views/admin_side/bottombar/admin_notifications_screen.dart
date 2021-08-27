import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/admin_side/admin_drawer_screen.dart';
import 'package:uetemergencyservice/views/admin_side/notification_shower_screen.dart';


class AdminNotificationScreen extends StatefulWidget {
  @override
  _AdminNotificationScreenState createState() => _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {

  List<String> imageList = [];
  bool loading = false;

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
        padding: const EdgeInsets.only(top: 16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("notifications").snapshots(),
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

                      var collection = FirebaseFirestore.instance.collection('notifications');
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
                    try{

//                      var url = snapshot.data()['img'];
//                      var response = await http.get(url);
//
//                      final Permission _permissionHandler = Permission.storage;
//                      var result = await _permissionHandler.request();
//                      if (result == PermissionStatus.granted) {
//                        final documentDirectory = Directory.systemTemp;
//                        File imgFile = new File('$documentDirectory/emergency.png');
//                        imgFile.writeAsBytesSync(response.bodyBytes);
//                        imageList = [];
//                        imageList.add(imgFile.toString());
//                        print(imageList);
//                      }


//                      Share.shareFiles(imageList, text: snapshot.data()['msj']);

                    share(snapshot.data()['img'], snapshot.data()['msj']);

                    }catch(e){
                      print(e.toString());
                    }
                      },
                    child: Icon(Icons.share, color: Colors.white, size: 30,)),
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
