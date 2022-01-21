import 'package:upi_pay/upi_pay.dart';
import 'user_payment.dart';

Future doUpiTransaction(ApplicationMeta appMeta) async {
  final UpiTransactionResponse response = await UpiPay.initiateTransaction(
    amount: '1.00',
    app: appMeta.upiApplication,
    receiverName: 'Divyanshu',
    receiverUpiAddress: 'Divyanshumeena321@okicici',
    transactionRef: 'UPITXREF0001',
    transactionNote: 'A UPI Transaction',
  );
  status = response.status.toString();
  if (status == "UpiTransactionStatus.success") {
    buyid = response.txnId.toString();
  }
}
