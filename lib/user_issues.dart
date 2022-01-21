import 'package:dormitory_management/student.dart';
import 'package:flutter/material.dart';
import 'functions.dart';

class UserIssuePage extends StatefulWidget {
  @override
  _UserIssuePageState createState() => _UserIssuePageState();
}

class _UserIssuePageState extends State<UserIssuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Issues"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF3FC979),
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
          color: Color(0xFF3FC979).withOpacity(0.25),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Issue no. : " + (number + 1).toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      issue,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: status
                          ? const Text(
                              "Resolved",
                              style: TextStyle(color: Colors.green),
                            )
                          : const Text(
                              "Not Resolved",
                              style: TextStyle(color: Colors.red),
                            )),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
