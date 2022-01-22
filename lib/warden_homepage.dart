import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dormitory_management/student.dart';
import 'package:dormitory_management/functions.dart';
import 'add_room.dart';
import 'report_retrieval.dart';
import 'admin_issues.dart';
import 'admin_payment.dart';
import 'user_profile.dart';
import 'list_admin.dart';
import 'admin_notice.dart';
import 'admin_profile.dart';
import 'warden_chat_list.dart';

class WardenHomePage extends StatefulWidget {
  WardenHomePage(
      {required this.name, required this.hostels, required this.title});

  String name;
  List<List<dynamic>> hostels;
  String title;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<WardenHomePage> {
  Functions functions = Functions();

  List<String> titl = const ["bh1", "bh2", "gh1", "gh2"];

  Map<String, List<String>> studentRecords = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Warden",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                decoration: BoxDecoration(color: Color(0xFF1DA1F2)),
              ),
              ListTile(
                title: const Text("Dormitory View"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                  title: const Text("Student Record"),
                  onTap: () async {
                    Functions func = Functions();
                    studentRecords = await func.Wardenstudentinfo(widget.title);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Student(studentRecords: studentRecords)));
                  }),
              ListTile(
                  title: const Text("Notice Board"),
                  onTap: () async {
                    Functions func = Functions();
                    studentRecords = await func.studentinfo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminNoticeBoard(),
                      ),
                    );
                  }),
              ListTile(
                title: const Text("Payment"),
                onTap: () async {
                  List<List<dynamic>> values =
                      await functions.WardenPaymentinfo(widget.title);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPaymentPage(
                        values: values,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Issues"),
                onTap: () async {
                  List<List<dynamic>> values = await functions.adminIssues();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminIssuePage(
                        values: values,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Report Retrieval"),
                onTap: () async {
                  Functions func = Functions();
                  studentRecords = await func.Wardenstudentinfo(widget.title);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReportRetrieval(studentRecords: studentRecords),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminProfile(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatListPage(
                  title: widget.title,
                ),
              ),
            );
          },
          child: Icon(Icons.chat),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout))
          ],
          title: const Text("Warden Home Page"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/iiita.jpg',
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: widget.hostels.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(widget.hostels[index][3])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        String beds = "";
                        String available = "";
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          if (snapshot.data!.docs[i].id == 'total') {
                            beds = snapshot.data!.docs[i]['beds'].toString();
                            available =
                                snapshot.data!.docs[i]['available'].toString();
                          }
                        }
                        return Container(
                          height: 150,
                          width: 350,
                          margin: EdgeInsets.symmetric(
                              vertical: 11, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xFF1DA1F2).withOpacity(0.25),
                          ),
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(widget.hostels[index][0]),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Beds : " + beds),
                                      Text("available : " + available),
                                    ]),
                              ],
                            ),
                            onTap: () async {
                              List<Map<String, dynamic>> val =
                                  await functions.roominfo(titl[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddRoom(val: val, title: titl[index]),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
