import 'package:dormitory_management/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListPage extends StatefulWidget {
  String title;
  ChatListPage({required this.title});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where('hostel', isEqualTo: widget.title)
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
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              email: snapshot.data!.docs[index]['email'],
                            ),
                          ),
                        );
                      },
                      title: Text(snapshot.data!.docs[index]['name']),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
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
