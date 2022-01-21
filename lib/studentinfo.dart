import 'package:flutter/material.dart';

class StudentInfo extends StatefulWidget {
  List<String> val = [];

  StudentInfo({required this.val});

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  String hostel = 'NA';

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Allot Room'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButton<String>(
                  value: hostel,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      hostel = newValue!;
                    });
                  },
                  items: <String>['NA', 'bh1', 'bh2', 'bh3', 'bh4', 'bh5']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> val = widget.val;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF3FC979),
          onPressed: () {
            _showMyDialog();
          },
          child: const Icon(Icons.edit),
        ),
        appBar: AppBar(
          title: const Text("Student Info"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                Container(
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 80,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF3FC979).withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 80,
                                            ),
                                            Text("Name"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Roll Number"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Room Number"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Document"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Move In"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Move Out"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Email")
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 80,
                                            ),
                                            Text(val[0]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(val[1]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(val[2]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(val[3]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(val[4]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(val[5]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(val[6]),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image:
                                        AssetImage("assets/images/iiita.jpg"))),
                          ),
                          radius: 80,
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
