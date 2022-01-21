import 'package:flutter/material.dart';
import 'package:dormitory_management/room_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dormitory_management/student.dart';
import 'package:dormitory_management/functions.dart';
import 'add_room.dart';
import 'report_retrieval.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'admin_issues.dart';
import 'admin_payment.dart';
import 'userHomePage.dart';
import 'user_profile.dart';
import 'list_admin.dart';

class Homepage extends StatefulWidget {
  Homepage({required this.name, required this.hostels});

  String name;
  List<List<dynamic>> hostels;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Functions functions = Functions();

  List<String> titl = const ["bh1", "bh2", "bh3", "bh4", "bh5", "gh1", "gh2"];

  Map<String, List<String>> studentRecords = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(widget.name),
                decoration: BoxDecoration(color: Color(0xFF3FC979)),
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
                    studentRecords = await func.studentinfo();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Student(studentRecords: studentRecords)));
                  }),
              ListTile(
                title: const Text("Payment"),
                onTap: () async {
                  List<List<dynamic>> values =
                      await functions.adminPaymentinfo();
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
                  studentRecords = await func.studentinfo();
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
                      builder: (context) => Profile(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Admins"),
                onTap: () async {
                  List<List<String>> admins = await functions.getAdmins();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAdmin(admins: admins),
                    ),
                  );
                },
              ),
            ],
          ),
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
          title: const Text("Home Page"),
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
                  return Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF3FC979).withOpacity(0.25),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Beds : " +
                                    widget.hostels[index][1].toString()),
                                Text("available : " +
                                    widget.hostels[index][2].toString()),
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
                },
              ),
            ),
          ],
        ));
  }
}
