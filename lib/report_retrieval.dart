import 'package:flutter/material.dart';
import 'functions.dart';

class ReportRetrieval extends StatefulWidget {
  Map<String, List<String>> studentRecords;
  ReportRetrieval({required this.studentRecords});

  @override
  _ReportRetrievalState createState() => _ReportRetrievalState();
}

class _ReportRetrievalState extends State<ReportRetrieval> {
  get keys => widget.studentRecords.keys.toList();
  List<bool> ischecked = [];
  List<String> todelete = [];

  bool checklist = false;
  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= widget.studentRecords.length; i++) {
      ischecked.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Retrieval"),
      ),
      body: ListView.builder(
          itemCount: widget.studentRecords.length,
          itemBuilder: (context, index) {
            bool alloted = true;
            if (widget.studentRecords[keys[index]]![2] == "") {
              alloted = false;
            }
            return GestureDetector(
                onTap: () async {
                  Functions functions = Functions();
                  await functions.generatePDF(keys[index]);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.studentRecords[keys[index]]![0]),
                    ],
                  ),
                  subtitle: Text(keys[index]),
                  trailing: checklist
                      ? Checkbox(
                          onChanged: (bool? value) {
                            setState(() {
                              ischecked[index] = value!;
                            });
                          },
                          value: ischecked[index],
                        )
                      : const SizedBox(),
                ));
          }),
    );
  }
}
