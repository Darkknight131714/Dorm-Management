// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

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
    UserIssuePage(),
    UserPaymentPage(),
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
          selectedItemColor: Color(0xFF3FC979),
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
              icon: Icon(Icons.error),
              label: "Issues",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: "Payment",
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
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout))
        ],
        title: Text("HomePage"),
      ),
      body: Center(
        child: Column(
          children: [
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
                      roominfo = await func.roominfo("bh3");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DormDetails(
                            name: "BH3",
                            roominfo: roominfo,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: hostelCard("Boys Hostel 3"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      roominfo = await func.roominfo("bh4");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DormDetails(
                            name: "BH4",
                            roominfo: roominfo,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: hostelCard("Boys Hostel 4"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      roominfo = await func.roominfo("bh5");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DormDetails(
                            name: "BH5",
                            roominfo: roominfo,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: hostelCard("Boys Hostel 5"),
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
    width: 350,
    margin: EdgeInsets.symmetric(vertical: 11),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Color(0xFF3FC979).withOpacity(0.25),
    ),
    child: Center(child: Text(title)),
  );
}
