import 'package:flutter/material.dart';
import 'functions.dart';
import 'room_details.dart';

class AllotRoom extends StatefulWidget {
  List<Map<String, dynamic>> val;
  String title;
  List<String> studentinfo;
  AllotRoom(
      {required this.val, required this.title, required this.studentinfo});

  @override
  _AllotRoomState createState() => _AllotRoomState();
}

class _AllotRoomState extends State<AllotRoom> {
  Functions functions = Functions();
  int room = 0, beds = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: widget.val.length,
        itemBuilder: (BuildContext context, int index) {
          Color vari = Colors.red;
          bool isEmpty = false;
          if (widget.val[index]["beds"] - widget.val[index]["allocated"] > 0) {
            vari = Colors.green;
            isEmpty = true;
          }
          return GestureDetector(
            onTap: () {
              if (isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                        "Allot ${widget.studentinfo[0]} to Room ${widget.val[index]["number"]}"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await functions.allotRoom(widget.studentinfo,
                              widget.title, widget.val[index]["number"]);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Allot Room"),
                      ),
                    ],
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Room is Full"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Exit"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.all(10),
              color: vari,
              child: Center(
                child: Text(widget.val[index]["number"].toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
