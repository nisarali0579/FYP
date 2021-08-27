import 'package:flutter/material.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/admin_side/bottombar/admin_home_screen.dart';
import 'package:uetemergencyservice/views/admin_side/bottombar/admin_notification_requests.dart';
import 'package:uetemergencyservice/views/admin_side/bottombar/admin_notifications_screen.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/notification_screen.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/profile_screen.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/user_home_screen.dart';

class AdminHome extends StatefulWidget {


  _AdminHomeState createState() => _AdminHomeState();

}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;
  List<Widget> tabs = [
    AdminHomeScreen(),
    AdminNotificationScreen(),
    AdminNotificationRequestsScreen(),
  ];

  @override
  void initState() {
    tabs = [
      AdminHomeScreen(),
      AdminNotificationScreen(),
      AdminNotificationRequestsScreen(),
    ];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 8,
          unselectedFontSize: 6,
          showUnselectedLabels: true,
          elevation: 3,
          backgroundColor: AppColors.mainColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,

          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Requests',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

        )
    );
  }

}