import 'package:dormitory_management/student.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'chat_screen.dart';

class UserIssuePage extends StatefulWidget {
  @override
  _UserIssuePageState createState() => _UserIssuePageState();
}

class _UserIssuePageState extends State<UserIssuePage> {
  String hostel = "", room = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (val[2] != "") {
      hostel = val[2][0] + val[2][1] + val[2][2];
      for (int i = 4; i < val[2].length; i++) {
        room = room + val[2][i];
      }
    } else {
      hostel = "NA";
      room = "NA";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Issues"),
        actions: [
          IconButton(
            onPressed: () async {
              Functions func = Functions();
              await func.createNewChat(val[3]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(email: val[3]),
                  ));
            },
            icon: Icon(Icons.chat),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: Color(0xFF1DA1F2),
        child: Icon(Icons.add),
        onPressed: () {
          String issue = "";
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Add Issue"),
              content: TextField(
                onChanged: (String value) {
                  issue = value;
                },
                expands: false,
                decoration: InputDecoration(hintText: "Issue"),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await functions.addIssue(issue);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Add Issue"),
                )
              ],
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: func_issues.length,
                itemBuilder: (BuildContext context, index) {
                  bool status = issues_resolved[index];
                  return issuecard(func_issues[index], status, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget issuecard(String issue, bool status, int number) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          color: Color(0xFF1DA1F2).withOpacity(0.25),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Issue : " + (number + 1).toString(),
                  style: TextStyle(
                      color: Color(0xff545454),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                Text(
                  issue,
                  style: TextStyle(
                      color: Color(0xff545454),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: status
                  ? const Text(
                      "    Resolved",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    )
                  : const Text(
                      "    Not Resolved",
                      style: TextStyle(color: Colors.red),
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
