import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'functions.dart';

class StudentInfo extends StatefulWidget {
  List<String> val = [];

  StudentInfo({required this.val});

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  String hostel = 'NA';
  String hostell = "", room = "";
  @override
  void initState() {
    super.initState();
    if (val[2] != "") {
      hostel = val[2][0] + val[2][1] + val[2][2];
      for (int i = 4; i < val[2].length; i++) {
        room = room + val[2][i];
      }
    } else {
      hostel = "NA";
      room = "NA";
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Allot Room'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButton<String>(
                  value: hostel,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      hostel = newValue!;
                    });
                  },
                  items: <String>['NA', 'bh1', 'bh2', 'bh3', 'bh4', 'bh5']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> value = widget.val;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1DA1F2),
        onPressed: () {
          _showMyDialog();
        },
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        title: const Text("Student Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 100),
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: SizedBox(
                            height: 80,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1DA1F2).withOpacity(0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(height: 70),
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Table(
                                    border: TableBorder.all(),
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Name"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(val[0]),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Roll No."),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/images/iiita.jpg"))),
                      ),
                      radius: 80,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
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
                    if (snapshot.data!.docs[i]['Email'] == value[3]) {
                      history = snapshot.data!.docs[i]['history'];
                      break;
                    }
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(history[index]),
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
