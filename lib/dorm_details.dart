import 'package:dormitory_management/functions.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'room_details.dart';

class DormDetails extends StatefulWidget {
  List<Map<String, dynamic>> roominfo;
  String name;
  DormDetails({required this.roominfo, required this.name});

  @override
  _DormDetailsState createState() => _DormDetailsState();
}

class _DormDetailsState extends State<DormDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: widget.roominfo.length,
        itemBuilder: (BuildContext context, int index) {
          Color background;
          int color = widget.roominfo[index]["beds"] -
              widget.roominfo[index]["allocated"];

          if (color == 0) {
            background = Colors.red;
          } else if (color <= 2) {
            background = Colors.yellowAccent;
          } else {
            background = Colors.green;
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomDetails(
                            number: index + 1,
                            roominfo: widget.roominfo[index],
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: background.withOpacity(0.6),
              ),
              margin: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
