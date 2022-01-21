import 'package:flutter/material.dart';
import 'functions.dart';
import 'room_details.dart';

class AddRoom extends StatefulWidget {
  List<Map<String, dynamic>> val;
  String title;
  AddRoom({required this.val, required this.title});

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
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
          Color background;
          int color =
              widget.val[index]["beds"] - widget.val[index]["allocated"];

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
                    roominfo: widget.val[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: background.withOpacity(0.6),
              ),
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(widget.val[index]["number"].toString()),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF3FC979),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Add Room"),
              content: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Room Number",
                    ),
                    onChanged: (String value) {
                      room = int.parse(value);
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Total Beds",
                    ),
                    onChanged: (String value) {
                      beds = int.parse(value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await functions.addroom(room, beds, widget.title);
                    widget.val.clear();
                    widget.val = await functions.roominfo(widget.title);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Add Room"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
