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
                return ListTile(
                  title: Text(snapshot.data!.docs[index]['notice']),
                  leading: Text(snapshot.data!.docs[index]['name']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
