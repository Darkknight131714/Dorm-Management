import 'package:dormitory_management/success.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'success.dart';
import 'failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int curr = -1;
String status = "", name = "", address = "", number = "", buyid = "";

late Razorpay _razorpay;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class UserPaymentPage extends StatefulWidget {
  const UserPaymentPage({Key? key}) : super(key: key);

  @override
  _UserPaymentPageState createState() => _UserPaymentPageState();
}

class _UserPaymentPageState extends State<UserPaymentPage> {
  int flag = 0;
  String hostel = payment[0] ? "Paid" : "Not Paid";
  String other = payment[1] ? "Paid" : "Not Paid";
  String hostelfee = "0", messfee = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (hostel == 'Not Paid') {
      hostelfee = "1000";
    }
    if (other == 'Not Paid') {
      messfee = "1000";
    }
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS: " + response.paymentId!);
    if (flag == 1) {
      setState(() {
        payment[0] = true;
        hostelfee = "0";
        hostel = "Paid";
      });
      FirebaseFirestore.instance
          .collection('students')
          .where('Email', isEqualTo: val[3])
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var element in querySnapshot.docs) {
          element.reference.update({'hostelfee': true});
        }
      });
    } else {
      setState(() {
        other = "Paid";
        payment[1] = true;
        messfee = "0";
      });
      FirebaseFirestore.instance
          .collection('students')
          .where('Email', isEqualTo: val[3])
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var element in querySnapshot.docs) {
          element.reference.update({'otherfee': true});
        }
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("SUCCESS: " + response.paymentId!),
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: " + response.code.toString() + " - " + response.message!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "ERROR: " + response.code.toString() + " - " + response.message!),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(
      "EXTERNAL WALLET: " + response.walletName!,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      "EXTERNAL WALLET: " + response.walletName!,
    )));
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_o4eo3gVWbgAyru',
      'amount': 100000,
      'name': 'Depri Corp.',
      'description': 'My Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    color: Color(0xFF1DA1F2).withOpacity(0.25),
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
                      Text("Amount Due : " + hostelfee),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          flag = 1;
                          if (hostelfee != '0') {
                            openCheckout();
                          } else {}
                        },
                        child: Text("Pay Hostel Fee"),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF1DA1F2),
                        ),
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
                    color: Color(0xFF1DA1F2).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mess Fees",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Fee : " + other),
                      Text("Amount Due : " + messfee),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          flag = 2;
                          if (messfee != '0') {
                            openCheckout();
                          } else {}
                        },
                        child: Text("Pay Other Fee"),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF1DA1F2),
                        ),
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
