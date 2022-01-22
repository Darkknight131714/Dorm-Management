import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'user_payment.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPaymentPage(),
                ),
              );
            },
            icon: Icon(Icons.payment),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
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
          Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Attendance History"),
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 0.5,
            endIndent: 15,
            indent: 15,
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('students').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                List<dynamic> history = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  if (snapshot.data!.docs[i]['Email'] == val[3]) {
                    history = snapshot.data!.docs[i]['history'];
                    break;
                  }
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(history[index]),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.5,
                            endIndent: 15,
                            indent: 15,
                          )
                        ],
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
