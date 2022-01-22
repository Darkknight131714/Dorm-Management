// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormitory_management/dorm_details.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:dormitory_management/admin_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'functions.dart';
import 'user_issues.dart';
import 'user_payment.dart';
import 'user_profile.dart';
import 'user_notice.dart';
import 'package:geolocator/geolocator.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class UserHomePage extends StatefulWidget {
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Functions functions = Functions();
  List<String> issue = [];
  @override
  int _index = 0;

  List<Widget> pages = [
    FirstScreen(),
    UserNoticeBoard(),
    UserIssuePage(),
    Profile(),
  ];
  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _index);
  }

  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF1DA1F2),
          type: BottomNavigationBarType.fixed,
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: "Notice Board",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.error),
              label: "Issues",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        body: PageView(
          children: pages,
          onPageChanged: onPageChanged,
          controller: _pageController,
        ));
  }

  void onPageChanged(int page) {
    setState(() {
      _index = page;
    });
  }
}

class FirstScreen extends StatelessWidget {
  Functions func = Functions();
  List<Map<String, dynamic>> roominfo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1DA1F2),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout))
        ],
        title: Text("Home",style: TextStyle(color: Color(0xffffffff), fontSize: 18),),
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  bool isInHostel = false;
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    if (snapshot.data!.docs[i]['Email'] == val[3]) {
                      isInHostel = snapshot.data!.docs[i]['isinhostel'];
                      break;
                    }
                  }
                  if (isInHostel) {
                    return ElevatedButton(
                      child: Text("Punch Out"),
                      onPressed: () async {
                        Functions func = Functions();
                        await func.punchInorOur(isInHostel);
                      },
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () async {
                        LocationPermission permission;
                        permission = await Geolocator.requestPermission();
                        Position position =
                            await Geolocator.getCurrentPosition();
                        int dist = Geolocator.distanceBetween(position.latitude,
                                position.longitude, 25.43, 81.77)
                            .toInt();
                        if (dist > 300) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              elevation: 0,
                              backgroundColor: Color.fromRGBO(29, 161, 242, 0.4),
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                "You are not near Hostel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          Functions func = Functions();
                          await func.punchInorOur(isInHostel);
                        }
                      },
                      child: Text("Punch In"),
                    );
                  }
                }
              },
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/iiita.jpg',
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async {
                      roominfo = await func.roominfo("bh1");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DormDetails(
                            name: "BH1",
                            roominfo: roominfo,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: hostelCard("Boys Hostel 1"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      roominfo = await func.roominfo("bh2");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DormDetails(
                            name: "BH2",
                            roominfo: roominfo,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: hostelCard("Boys Hostel 2"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      roominfo = await func.roominfo("gh1");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DormDetails(
                            name: "GH1",
                            roominfo: roominfo,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: hostelCard("Girls Hostel 1"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      roominfo = await func.roominfo("gh2");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DormDetails(
                            name: "GH2",
                            roominfo: roominfo,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: hostelCard("Girls Hostel 2"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget hostelCard(String title) {
  return Container(
    height: 50,
    width: 300,
    margin: EdgeInsets.symmetric(vertical: 11),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Color(0xFF1DA1F2).withOpacity(0.65),
    ),
    child: Center(child: Text(title, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600, fontSize: 16),),),
  );
}
