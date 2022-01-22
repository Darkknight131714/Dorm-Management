import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'admin_homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dormitory_management/functions.dart';
import 'userHomePage.dart';
import 'register.dart';
import 'constants.dart';
import 'warden_homepage.dart';

String hostell = "";

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: ktextfield.copyWith(hintText: "Email")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: ktextfield.copyWith(hintText: "password")),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  Functions func = Functions();

                  if (await func.signin(email, password)) {
                    val.clear();
                    await func.profileinfo(email);
                    String name = await func.userpower();
                    if (name == "HelloWorld") {
                      await FirebaseFirestore.instance
                          .collection('warden')
                          .where('email', isEqualTo: email)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var element in querySnapshot.docs) {
                          hostell = element['hostel'];
                          print(element['hostel']);
                        }
                      });
                      List<List<dynamic>> hostels =
                          await func.Wardenhostels(hostell);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WardenHomePage(
                            name: name,
                            hostels: hostels,
                            title: hostell,
                          ),
                        ),
                      );
                    } else if (name != "") {
                      List<List<dynamic>> hostels = await func.hostels();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homepage(
                            name: name,
                            hostels: hostels,
                          ),
                        ),
                      );
                    } else {
                      await func.userIssue(val[1]);
                      Navigator.push(
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
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF3FC979),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(350, 42),
                ),
                child: const Text("Log In"),
              ),
            ),
            Text("Not a member? "),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                },
                child: const Text("Register"),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF3FC979),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(350, 42)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
