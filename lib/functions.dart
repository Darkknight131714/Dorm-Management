import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

List<String> val = [];
var pdf = pw.Document();
List<String> func_issues = [];
List<bool> issues_resolved = [];
List<bool> payment = [];

class Functions {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // String email="";
  // String password="";
  // //bool admin = false;
  //
  //
  // Functions(String email, String password){
  //   this.email = email;
  //   this.password = password;
  // }

  Future<bool> signin(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      return false;
    }
  }

  Future<String> userpower() async {
    String name = "";

    if (auth.currentUser != null) {
      CollectionReference users = firestore.collection('Users');
      await users.get().then((QuerySnapshot querySnapshot) {
        for (var element in querySnapshot.docs) {
          if (element["email"].toString() ==
              auth.currentUser?.email.toString()) {
            name = element["name"];
          }
        }
      });
    }

    return name;
  }

  Future<List<List<dynamic>>> hostels() async {
    List<List<dynamic>> hostels = [];

    await firestore
        .collection('hostels')
        .orderBy('name')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var element in querySnapshot.docs) {
        //print(element["info"]);

        DocumentReference docRef =
            FirebaseFirestore.instance.doc(element["info"]);

        //print(docRef.toString());

        var a = await userData(docRef);

        print(a()["beds"]);

        hostels.add([
          element["name"],
          a()["beds"],
          a()["available"],
        ]);
      }
    });

    return hostels;
  }

  Future<dynamic> userData(DocumentReference user) async {
    DocumentSnapshot userRef = await user.get();
    print(userRef.data());
    return userRef.data;
  }

  Future hostelstatusupdate(int count, String hostel, bool roomadded) async {
    DocumentSnapshot doc =
        await firestore.collection(hostel).doc("total").get();

    doc.reference.update({
      "available": doc["available"] + count,
    });

    if (roomadded) {
      doc.reference.update({
        "beds": doc["beds"] + count,
      });
    }
  }

  Future<Map<String, List<String>>> studentinfo() async {
    Map<String, List<String>> studentRecords = {};

    CollectionReference students = firestore.collection('students');
    await students.get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        studentRecords[element["Rollno"].toString()] = [
          element["Name"].toString(),
          element["Rollno"].toString(),
          element["Room"].toString(),
          element["Document"].toString(),
          element["Movein"].toString(),
          element["Moveout"].toString(),
          element["Email"].toString(),
        ];
      }

      print(studentRecords.keys);
    });

    return studentRecords;
  }

  Future roominfo(String room) async {
    List<Map<String, dynamic>> rooms = [];

    CollectionReference hostel = firestore.collection(room);
    await hostel.orderBy("number").get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        rooms.add({
          "allocated": element["allocated"],
          "beds": element["beds"],
          "number": element["number"],
          "students": element["students"],
        });
      }
    });

    return rooms;
  }

  Future addroom(int room, int beds, String hostelname) async {
    await hostelstatusupdate(beds, hostelname, true);

    CollectionReference hostel = firestore.collection(hostelname);
    await hostel.add({
      "allocated": 0,
      "beds": beds,
      "number": room,
      "students": [],
    });
  }

  Future<bool> register(String email, String password) async {
    bool val = false;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      val = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return val;
  }

  Future profileinfo(String email) async {
    CollectionReference students = firestore.collection('students');
    await students.get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        if (element["Email"] == email) {
          val.clear();
          val.add(element["Name"].toString());
          val.add(element["Rollno"].toString());
          val.add(element["Room"].toString());
          val.add(element["Document"].toString());
          val.add(element["Movein"].toString());
          val.add(element["Moveout"].toString());
          val.add(element["Email"].toString());
          payment.clear();
          payment.add(element["hostelfee"]);
          payment.add(element["otherfee"]);
          break;
        }
      }
    });
  }

  Future allotRoom(
      List<String> studentinfo, String hostelname, int room) async {
    await hostelstatusupdate(-1, hostelname, false);

    await firestore
        .collection('students')
        .where('Name', isEqualTo: studentinfo[0])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        documentSnapshot.reference.update({
          "Name": studentinfo[0],
          "Document": "Aadhar",
          "Email": studentinfo[6],
          "Movein": studentinfo[4],
          "Moveout": studentinfo[5],
          "Rollno": studentinfo[1],
          "Room": "${hostelname} ${room}",
        });
      }
    });
    await firestore
        .collection(hostelname)
        .where('number', isEqualTo: room)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        print(documentSnapshot["students"]);
        documentSnapshot.reference.update({
          "allocated": documentSnapshot["allocated"] + 1,
          "beds": documentSnapshot["beds"],
          "number": room,
          "students": FieldValue.arrayUnion([studentinfo[1]])
        });
      });
    });
  }

  Future removeRoom(List<String> studentinfo) async {
    String hostelname =
        studentinfo[2][0] + studentinfo[2][1] + studentinfo[2][2];

    await hostelstatusupdate(1, hostelname, false);

    int room;
    String a = "";
    for (int i = 3; i < studentinfo[2].length; i++) {
      a += studentinfo[2][i];
    }
    room = int.parse(a);
    await firestore
        .collection('students')
        .where('Rollno', isEqualTo: studentinfo[1])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        documentSnapshot.reference.update({
          "Name": studentinfo[0],
          "Document": "Aadhar",
          "Email": studentinfo[6],
          "Movein": studentinfo[4],
          "Moveout": studentinfo[5],
          "Rollno": studentinfo[1],
          "Room": "",
        });
      }
    });
    await firestore
        .collection(hostelname)
        .where('number', isEqualTo: room)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        documentSnapshot.reference.update({
          "allocated": documentSnapshot["allocated"] - 1,
          "beds": documentSnapshot["beds"],
          "number": room,
          "students": FieldValue.arrayRemove([studentinfo[1]])
        });
      });
    });
  }

  Future generatePDF(String rollno) async {
    List<pw.Widget> issues = [];
    await firestore
        .collection("issues")
        .where('rollno', isEqualTo: rollno)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        String temp = documentSnapshot["issue"];
        bool tem = documentSnapshot["resolved"];
        String cond = tem ? "Resolved" : "Not Resolved";
        issues.add(pw.Text(temp + "     " + cond));
      });
    });
    pdf = pw.Document();
    await firestore
        .collection('students')
        .where('Rollno', isEqualTo: rollno)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        String hostelfee = documentSnapshot["hostelfee"] ? "Paid" : "Not Paid";
        String otherfee = documentSnapshot["otherfee"] ? "Paid" : "Not Paid";
        pdf.addPage(
          pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Center(
                    child: pw.Column(children: [
                  pw.Text("Name: " + documentSnapshot["Name"]),
                  pw.Text("Roll Number: " + documentSnapshot["Rollno"]),
                  pw.Text("Room: " + documentSnapshot["Room"]),
                  pw.Text("Email: " + documentSnapshot["Email"]),
                  pw.Text("Document: " + documentSnapshot["Document"]),
                  pw.Text("Move In Date: " + documentSnapshot["Movein"]),
                  pw.Text("Move Out Date: " + documentSnapshot["Moveout"]),
                  pw.Text("Hostel Fee Status: " + hostelfee),
                  pw.Text("Other Fee Status: " + otherfee),
                  pw.Column(children: issues),
                ]));
              }),
        );
      });
    });
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/${rollno}");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open("${output.path}/${rollno}");
  }

  Future removestudent(Map<String, List<String>> studentRecords,
      Set<String> students, List<String> email) async {
    int k = 0;

    for (int i = 0; i < students.length; i++) {
      if (studentRecords[students.elementAt(i)]![2] != "") {
        await removeRoom(studentRecords[students.elementAt(i)]!);
      }
    }

    await firestore
        .collection('students')
        .orderBy("Rollno")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        if (k == students.length) {
          break;
        }
        if (element["Rollno"] == students.elementAt(k)) {
          firestore.collection('students').doc(element.id).delete();
          k++;
        }
      }
    });
    for (int i = 0; i < email.length; i++) {
      await firestore
          .collection('uid')
          .where('email', isEqualTo: email[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.delete();
        });
      });
    }
  }

  Future<List<List<dynamic>>> adminIssues() async {
    List<List<dynamic>> ans = [];
    int index = 0;
    await firestore
        .collection('issues')
        .where('resolved', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        ans.add([]);
        ans[index].add(documentSnapshot["issue"]);
        ans[index].add(documentSnapshot["name"]);
        ans[index].add(documentSnapshot["resolved"]);
        ans[index].add(documentSnapshot["rollno"]);
        index++;
      });
    });
    print(ans);
    return ans;
  }

  Future markResolved(String rollno, String issue) async {
    await firestore
        .collection('issues')
        .where('rollno', isEqualTo: rollno)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        if (documentSnapshot["issue"] == issue) {
          documentSnapshot.reference.update({
            "issue": issue,
            "name": documentSnapshot["name"],
            "rollno": rollno,
            "resolved": true,
          });
        }
      });
    });
  }

  Future userIssue(String rollno) async {
    func_issues.clear();
    issues_resolved.clear();
    await firestore
        .collection('issues')
        .where('rollno', isEqualTo: rollno)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        func_issues.add(documentSnapshot["issue"]);
        issues_resolved.add(documentSnapshot["resolved"]);
      });
    });
  }

  Future addIssue(String issue) async {
    CollectionReference issues = firestore.collection("issues");
    issues.add({
      "issue": issue,
      "name": val[0],
      "rollno": val[1],
      "resolved": false,
    });
    func_issues.add(issue);
    issues_resolved.add(false);
  }

  Future<List<List<dynamic>>> adminPaymentinfo() async {
    CollectionReference students = firestore.collection('students');
    List<List<dynamic>> ans = [];
    int index = 0;
    await students.get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        ans.add([]);
        ans[index].add(element["Name"]);
        ans[index].add(element["Rollno"]);
        ans[index].add(element["hostelfee"]);
        ans[index].add(element["otherfee"]);
        index++;
      }
    });
    return ans;
  }

  Future deleteUserFromAuthentication(List<String> email) async {
    String adminemail = val[6];
    String adminpass = "";
    List<String> password = [];
    FirebaseAuth _auth = FirebaseAuth.instance;
    await firestore
        .collection('uid')
        .where('email', isEqualTo: adminemail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) async {
        adminpass = documentSnapshot["password"];
      });
    });
    for (int i = 0; i < email.length; i++) {
      await firestore
          .collection('uid')
          .where('email', isEqualTo: email[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          password.add(documentSnapshot["password"]);
        });
      });
    }
    for (int i = 0; i < email.length; i++) {
      await _auth.signInWithEmailAndPassword(
          email: email[i], password: password[i]);
      await _auth.currentUser!.delete();
    }
    await _auth.signInWithEmailAndPassword(
        email: adminemail, password: adminpass);
  }

  Future addAdmin(String email, String name) async {
    CollectionReference users = firestore.collection('Users');
    await users.add({
      "name": name,
      "email": email,
    });
  }

  Future<List<List<String>>> getAdmins() async {
    List<List<String>> ans = [];
    int index = 0;
    CollectionReference users = firestore.collection('Users');
    await users.get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        ans.add([]);
        ans[index].add(element["name"]);
        ans[index].add(element["email"]);
        index++;
      }
    });
    return ans;
  }

  Future removeAdmin(String email) async {
    await firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) async {
        await documentSnapshot.reference.delete();
      });
    });
  }
}
