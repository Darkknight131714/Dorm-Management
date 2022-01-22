import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'user_payment.dart';

class AdminProfile extends StatefulWidget {
  @override
  State<AdminProfile> createState() => _ProfileState();
}

class _ProfileState extends State<AdminProfile> {
  @override
  void initState() {
    bool flag = val[2] != "";
    super.initState();
    if (flag == true) {
      hostel = val[2][0] + val[2][1] + val[2][2];
      for (int i = 4; i < val[2].length; i++) {
        room = room + val[2][i];
      }
    } else {
      hostel = "NA";
      room = "NA";
    }
  }

  String room = "", hostel = "";
  List<String> lead = ["Name", "Roll Number", "Room Number", "Email"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AdminProfile"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/iiita.jpg"))),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(lead[0]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(val[0]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(lead[1]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(val[1]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Hostel"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(hostel.toUpperCase()),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Room"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(room),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
