import 'package:dormitory_management/functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  String email;

  ChatScreen({required this.email});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message = "";
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.email)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return Flexible(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment:
                              snapshot.data!.docs[index]['sender'] == val[3]
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.docs[index]["sender"],
                              style: TextStyle(fontSize: 14),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: snapshot.data!.docs[index]['sender'] ==
                                        val[3]
                                    ? Color(0xFF1DA1F2)
                                    : Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        snapshot.data!.docs[index]['sender'] ==
                                                val[3]
                                            ? 30
                                            : 0),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(
                                        snapshot.data!.docs[index]['sender'] ==
                                                val[3]
                                            ? 0
                                            : 30)),
                              ),
                              child: Text(
                                snapshot.data!.docs[index]["msg"],
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          TextField(
            controller: _controller,
            onChanged: (value) {
              message = value;
            },
            decoration: InputDecoration(
                hintText: "Enter Message",
                filled: true,
                fillColor: Colors.grey,
                suffix: IconButton(
                  onPressed: () async {
                    Functions func = Functions();
                    await func.sendMessage(widget.email, val[3], message);
                    _controller.clear();
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                  },
                  icon: Icon(Icons.send),
                )),
          ),
        ],
      ),
    );
  }
}
