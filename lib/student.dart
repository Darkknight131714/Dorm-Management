import 'dart:ffi';
import 'package:flutter/material.dart';
import 'studentinfo.dart';
import 'allot_dormview.dart';
import 'functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

Functions functions = Functions();

class Student extends StatefulWidget {
  Map<String, List<String>> studentRecords;

  Student({required this.studentRecords});

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  get keys => widget.studentRecords.keys.toList();
  List<bool> ischecked = [];
  Set<String> todelete = {};
  List<String> emailsToBeDeleted = [];

  bool checklist = false;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= widget.studentRecords.length; i++) {
      ischecked.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    todelete.clear();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student record"),
      ),
      floatingActionButton: Visibility(
        visible: checklist,
        child: FloatingActionButton(
          backgroundColor: Color(0xFF3FC979),
          onPressed: () async {
            for (int i = 0; i < ischecked.length; i++) {
              if (ischecked[i] == true) {
                todelete.add(keys[i]);
                emailsToBeDeleted.add(widget.studentRecords[keys[i]]![6]);
              }
            }

            FirebaseAuth _auth = FirebaseAuth.instance;
            await _auth.signOut();
            await functions.deleteUserFromAuthentication(emailsToBeDeleted);
            await functions.removestudent(
                widget.studentRecords, todelete, emailsToBeDeleted);
            Navigator.pop(context);
          },
          child: const Icon(Icons.delete_forever),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.studentRecords.length,
          itemBuilder: (context, index) {
            bool alloted = true;
            if (widget.studentRecords[keys[index]]![2] == "") {
              alloted = false;
            }
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentInfo(val: widget.studentRecords[keys[index]]!),
                    ),
                  );
                },
                onLongPress: () {
                  checklist = checklist ? false : true;

                  for (var i = 0; i <= widget.studentRecords.length; i++) {
                    ischecked[i] = false;
                  }

                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF3FC979).withOpacity(0.25),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.studentRecords[keys[index]]![0]),
                              Text(
                                keys[index],
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),
                              )
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              if (alloted == false) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Allot_DormView(
                                        admin: true,
                                        studentinfo: widget
                                            .studentRecords[keys[index]]!),
                                  ),
                                );
                              } else {
                                functions.removeRoom(
                                    widget.studentRecords[keys[index]]!);
                                Navigator.pop(context);
                              }
                            },
                            child: alloted
                                ? const Text(
                                    "Remove Room",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : const Text("Allot Room"),
                          )
                        ],
                      ),
                      trailing: checklist
                          ? Checkbox(
                              onChanged: (bool? value) {
                                setState(() {
                                  ischecked[index] = value!;
                                });
                              },
                              value: ischecked[index],
                            )
                          : const SizedBox(),
                    ),
                  ),
                ));
          }),
    );
  }
}
