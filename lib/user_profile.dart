import 'package:flutter/material.dart';
import 'functions.dart';

class Profile extends StatelessWidget {
  @override
  List<String> lead = ["Name", "Roll Number", "Room Number", "Email"];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
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
        ],
      ),
    );
  }
}
