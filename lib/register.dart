import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userHomePage.dart';
import 'loginpage.dart';
import 'constants.dart';
import 'admin_homepage.dart';
import 'package:geolocator/geolocator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  late String name, Rollno, room, email, pass;
  Functions functions = Functions();
  late Position position;
  int dist = 0;
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    final _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: ktextfield.copyWith(hintText: "Name"),
                onChanged: (String value) {
                  name = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: ktextfield.copyWith(hintText: "Roll Number"),
                onChanged: (String value) {
                  Rollno = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: ktextfield.copyWith(hintText: "Email"),
                onChanged: (String value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: ktextfield.copyWith(hintText: "Password"),
                onChanged: (String value) {
                  pass = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                child: Text("Get Location"),
                onPressed: () async {
                  LocationPermission permission;
                  permission = await Geolocator.requestPermission();
                  position = await Geolocator.getCurrentPosition();
                  dist = Geolocator.distanceBetween(
                          position.latitude, position.longitude, 25.43, 81.77)
                      .toInt();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF1DA1F2),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        "Location Received",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF3FC979),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(350, 42)),
                onPressed: () async {
                  if (dist != 0) {
                    bool val1 = await functions.register(email, pass);
                    if (val1) {
                      _firestore.collection("students").add({
                        "Name": name,
                        "Rollno": Rollno,
                        "Room": "",
                        "Email": email,
                        "hostelfee": false,
                        "otherfee": false,
                        "isinhostel": false,
                        "history": [],
                        "distance": dist,
                      });
                      _firestore.collection("uid").add({
                        "email": email,
                        "password": pass,
                      });
                      val.clear();
                      val.add(name);
                      val.add(Rollno);
                      val.add("");
                      val.add(email);
                      func_issues.clear();
                      issues_resolved.clear();
                      payment.clear();
                      payment.add(false);
                      payment.add(false);
                      await functions.userIssue(val[1]);
                      String flag = await functions.userpower();
                      if (flag != "") {
                        List<List<dynamic>> hostels = await functions.hostels();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(
                              name: name,
                              hostels: hostels,
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserHomePage(),
                          ),
                        );
                      }
                    } else {
                      const snackbar = SnackBar(
                        backgroundColor: Colors.blueGrey,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Incorrect User Credentials",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blueGrey,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Please Get Location",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Register"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
