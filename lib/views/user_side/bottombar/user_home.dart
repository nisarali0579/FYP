import 'package:flutter/material.dart';
import 'package:uetemergencyservice/utils/colors.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/notification_screen.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/profile_screen.dart';
import 'package:uetemergencyservice/views/user_side/bottombar/user_home_screen.dart';

class UserHome extends StatefulWidget {


  _UserHomeState createState() => _UserHomeState();

}

class _UserHomeState extends State<UserHome> {
  int _currentIndex = 0;
  List<Widget> tabs = [
    UserHomeScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    tabs = [
      UserHomeScreen(),
      NotificationScreen(),
      ProfileScreen(),
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
              icon: Icon(Icons.person_pin),
              label: 'Profile',
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