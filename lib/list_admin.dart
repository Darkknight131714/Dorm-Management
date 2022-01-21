import 'package:flutter/material.dart';
import 'functions.dart';

Functions functions = Functions();

class ListAdmin extends StatefulWidget {
  List<List<String>> admins;
  ListAdmin({required this.admins});

  @override
  _ListAdminState createState() => _ListAdminState();
}

class _ListAdminState extends State<ListAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admins"),
      ),
      body: ListView.builder(
          itemCount: widget.admins.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.admins[index][0]),
              trailing: Text(widget.admins[index][1]),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(
                              "Remove ${widget.admins[index][0]} from Admin"),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                await functions
                                    .removeAdmin(widget.admins[index][1]);
                                widget.admins.clear();
                                widget.admins = await functions.getAdmins();
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text("Remove"),
                            ),
                          ],
                        ));
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          String name = "", email = "";
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Add Admin"),
              content: Column(
                children: [
                  TextField(
                    onChanged: (String value) {
                      name = value;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                  TextField(
                    onChanged: (String value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    await functions.addAdmin(email, name);
                    widget.admins.clear();
                    widget.admins = await functions.getAdmins();
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Add Admin"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
