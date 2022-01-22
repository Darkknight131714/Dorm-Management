import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'user_payment.dart';

class Profile extends StatelessWidget {
  @override
  List<String> lead = ["Name", "Roll Number", "Room Number", "Email"];
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
          Expanded(
            flex: 2,
            child: Container(
              child: ListView.builder(
                  itemCount: val.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      child: ListTile(
                        leading: Text(lead[index] + ": "),
                        title: Text(val[index]),
                      ),
                    );
                  }),
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
                  if (snapshot.data!.docs[i]['Email'] == val[3]) {
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
    );
  }
}
