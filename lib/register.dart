import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userHomePage.dart';
import 'loginpage.dart';
import 'constants.dart';
import 'admin_homepage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  late String movein, moveout, name, Rollno, room, email, pass;
  Functions functions = Functions();
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
                decoration: ktextfield.copyWith(hintText: "Move In"),
                onChanged: (String value) {
                  movein = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: ktextfield.copyWith(hintText: "Move Out"),
                onChanged: (String value) {
                  moveout = value;
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
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF3FC979),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(350, 42)),
                onPressed: () async {
                  bool val1 = await functions.register(email, pass);
                  if (val1) {
                    _firestore.collection("students").add({
                      "Name": name,
                      "Rollno": Rollno,
                      "Room": "",
                      "Movein": movein,
                      "Moveout": moveout,
                      "Document": "Aadhar",
                      "Email": email,
                      "hostelfee": false,
                      "otherfee": false,
                    });
                    _firestore.collection("uid").add({
                      "email": email,
                      "password": pass,
                    });
                    val.clear();
                    val.add(name);
                    val.add(Rollno);
                    val.add("");
                    val.add("Aadhar");
                    val.add(movein);
                    val.add(moveout);
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
