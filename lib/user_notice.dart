import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class UserNoticeBoard extends StatefulWidget {
  const UserNoticeBoard({Key? key}) : super(key: key);

  @override
  _UserNoticeBoardState createState() => _UserNoticeBoardState();
}

class _UserNoticeBoardState extends State<UserNoticeBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notice Board"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('noticeboard').snapshots(),
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
