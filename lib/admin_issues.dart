import 'package:flutter/material.dart';
import 'functions.dart';

class AdminIssuePage extends StatefulWidget {
  List<List<dynamic>> values;
  AdminIssuePage({required this.values});

  @override
  _AdminIssuePageState createState() => _AdminIssuePageState();
}

class _AdminIssuePageState extends State<AdminIssuePage> {
  Functions functions = Functions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Issues"),
      ),
      body: ListView.builder(
          itemCount: widget.values.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3FC979).withOpacity(0.25),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Issue no. : " + (index + 1).toString()),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.values[index][1],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.values[index][0],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () async {
                            await functions.markResolved(
                                widget.values[index][3],
                                widget.values[index][0]);
                            widget.values.clear();
                            widget.values = await functions.adminIssues();
                            setState(() {});
                          },
                          child: Text("Mark as Resolved"),
                        ),
                      ),
                    ]),
              ),
            );
          }),
    );
  }
}
