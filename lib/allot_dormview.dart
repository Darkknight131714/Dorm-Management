import 'package:flutter/material.dart';
import 'package:dormitory_management/room_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dormitory_management/student.dart';
import 'package:dormitory_management/functions.dart';
import 'allot_room.dart';

class Allot_DormView extends StatefulWidget {
  Allot_DormView({required this.admin, required this.studentinfo});
  List<String> studentinfo;
  final bool admin;

  @override
  _Allot_DormViewState createState() => _Allot_DormViewState();
}

class _Allot_DormViewState extends State<Allot_DormView> {
  Functions functions = Functions();
  List<String> hostels = const [
    "Boys Hostel 1",
    "Boys Hostel 2",
    "Boys Hostel 3",
    "Boys Hostel 4",
    "Boys Hostel 5",
    "Girls Hostel 1",
    "Girls Hostel 2"
  ];
  List<String> titl = const ["bh1", "bh2", "bh3", "bh4", "bh5", "gh1", "gh2"];

  Map<String, List<String>> studentRecords = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Allot Hostel"),
      ),
      body: ListView.builder(
        itemCount: hostels.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(hostels[index]),
            onTap: () async {
              List<Map<String, dynamic>> val =
                  await functions.roominfo(titl[index]);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AllotRoom(
                    val: val,
                    title: titl[index],
                    studentinfo: widget.studentinfo,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
