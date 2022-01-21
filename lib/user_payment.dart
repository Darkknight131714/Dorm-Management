import 'package:dormitory_management/success.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:upi_pay/upi_pay.dart';
import 'func_upipay.dart';
import 'success.dart';
import 'failure.dart';

int curr = -1;
String status = "", name = "", address = "", number = "", buyid = "";

class UserPaymentPage extends StatefulWidget {
  const UserPaymentPage({Key? key}) : super(key: key);

  @override
  _UserPaymentPageState createState() => _UserPaymentPageState();
}

class _UserPaymentPageState extends State<UserPaymentPage> {
  @override
  Widget build(BuildContext context) {
    String hostel = payment[0] ? "Paid" : "Not Paid";
    String other = payment[1] ? "Paid" : "Not Paid";
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Info"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF3FC979).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hostel",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Fee : " + hostel),
                      Text("Amount Due : 0.00"),
                      Text("Due date : 22/09/2022"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final List<ApplicationMeta> appMetaList =
                              await UpiPay.getInstalledUpiApplications(
                                  statusType:
                                      UpiApplicationDiscoveryAppStatusType.all);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                  "UPIs: " + appMetaList.length.toString()),
                              actions: [
                                Container(
                                  height: 300,
                                  width: 300,
                                  child: (appMetaList.length == 0)
                                      ? Text("No UPI INSTALLED")
                                      : ListView.builder(
                                          itemCount: appMetaList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              child: GestureDetector(
                                                  onTap: () async {
                                                    curr = index;
                                                    await doUpiTransaction(
                                                        appMetaList[curr]);
                                                    if (status ==
                                                        "UpiTransactionStatus.success") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SuccessScreen(),
                                                        ),
                                                      );
                                                    } else if (status ==
                                                        "UpiTransactionStatus.submitted") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SuccessScreen(),
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FailureScreen(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          appMetaList[index]
                                                              .iconImage(48),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(appMetaList[
                                                                  index]
                                                              .upiApplication
                                                              .appName
                                                              .toString()),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Pay Hostel Fee"),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF3FC979)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF3FC979).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amenities",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Fee : " + other),
                      Text("Amount Due : 0.00"),
                      Text("Due date : 22/09/2022"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final List<ApplicationMeta> appMetaList =
                              await UpiPay.getInstalledUpiApplications(
                                  statusType:
                                      UpiApplicationDiscoveryAppStatusType.all);
                          for (int i = 0; i < appMetaList.length; i++) {
                            print(appMetaList[i].upiApplication);
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                  "UPIs: " + appMetaList.length.toString()),
                              actions: [
                                Container(
                                  height: 300,
                                  width: 300,
                                  child: (appMetaList.length == 0)
                                      ? Text("No UPI INSTALLED")
                                      : ListView.builder(
                                          itemCount: appMetaList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              child: GestureDetector(
                                                  onTap: () async {
                                                    curr = index;
                                                    await doUpiTransaction(
                                                        appMetaList[curr]);
                                                    if (status ==
                                                        "UpiTransactionStatus.success") {
                                                      print("Hello");
                                                    } else if (status ==
                                                        "UpiTransactionStatus.submitted") {
                                                      print("IDK");
                                                    } else {
                                                      print("some error:" +
                                                          status);
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          appMetaList[index]
                                                              .iconImage(48),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(appMetaList[
                                                                  index]
                                                              .upiApplication
                                                              .appName
                                                              .toString()),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Pay Other Fee"),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF3FC979)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
