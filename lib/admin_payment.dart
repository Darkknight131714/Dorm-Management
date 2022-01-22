import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'functions.dart';

class AdminPaymentPage extends StatefulWidget {
  List<List<dynamic>> values;
  AdminPaymentPage({required this.values});
  @override
  _AdminPaymentPageState createState() => _AdminPaymentPageState();
}

class _AdminPaymentPageState extends State<AdminPaymentPage> {
  Functions functions = Functions();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Page"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: 405,
                margin: EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF1DA1F2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Student Info",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "Hostel Fee",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Other Fee",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 14,
            child: Container(
              child: ListView.builder(
                itemCount: widget.values.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    height: 100,
                    width: 400,
                    margin: EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF1DA1F2).withOpacity(0.25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    minWidth: 100, maxWidth: 100),
                                child: Text(
                                  widget.values[index][0],
                                ),
                              ),
                              Text(widget.values[index][1]
                                  .toString()
                                  .toUpperCase()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Icon(widget.values[index][2]
                            ? Icons.check
                            : Icons.close),
                        SizedBox(
                          width: 90,
                        ),
                        Icon(widget.values[index][3]
                            ? Icons.check
                            : Icons.close),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
