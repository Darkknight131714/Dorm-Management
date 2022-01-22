import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'functions.dart';

class AdminNoticeBoard extends StatefulWidget {
  const AdminNoticeBoard({Key? key}) : super(key: key);

  @override
  _AdminNoticeBoardState createState() => _AdminNoticeBoardState();
}

class _AdminNoticeBoardState extends State<AdminNoticeBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notice Board"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          String newNotice = "";
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Text("Add New Notice"),
                    TextField(
                        decoration: InputDecoration(
                            suffix: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (newNotice != "") {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Sure You want to Send that notice?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Functions func = Functions();
                                            await func.addNotice(
                                                newNotice, val[0]);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                        )),
                        onChanged: (value) {
                          newNotice = value;
                        }),
                  ],
                );
              });
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('noticeboard')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    ListTile(
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          snapshot.data!.docs[index]['notice'],
                          style: TextStyle(
                              color: Color(0xff545454),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      title: Text(
                        "Warden: " + snapshot.data!.docs[index]['name'],
                        style: TextStyle(
                            color: Color(0xff545454),
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
