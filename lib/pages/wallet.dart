// import 'dart:convert';
import 'dart:ui';
import 'package:app/widget/widget_support.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import '../widget/app_constant.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  // Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                          "Wallet",
                          style: AppWidget.HeadlineTextFieldStyle(),
                        )))),
            SizedBox(height: 30.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
              child: Row(
                children: [
                  Image.asset(
                    "images/wallet.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Wallet",
                        style: AppWidget.LightTextFieldStyle(),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "\u{20B9}" + "100",
                        style: AppWidget.boldTextFieldStyle(),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Add money",
                style: AppWidget.boldTextFieldStyle(),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE9E2E2)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "\u{20B9}" + "100",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE9E2E2)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "\u{20B9}" + "500",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE9E2E2)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "\u{20B9}" + "1000",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE9E2E2)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "\u{20B9}" + "2000",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                )
              ],
            ),
            SizedBox(height: 50.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.symmetric(vertical: 12.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  "Add Money",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// Future<void> makePayment(String amount) async {
//   try {
//     paymentIntent = await createPaymentIntent(amount, 'INR');
//     await Stripe.instance
//         .initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//                 paymentIntentClientSecret: paymentIntent!['client_secret'],
//                 style: ThemeMode.dark,
//                 merchantDisplayName: 'Adan'))
//         .then((value) {});
//
//     displayPaymentSheet(amount);
//   } catch (e, s) {
//     print('exception: $e$s');
//   }
// }
//
// displayPaymentSheet(String amount) async {
//   try {
//     await Stripe.instance.presentPaymentSheet().then((value) async {
//       showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//                 content: Column(
//                   children: [
//                     Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                     ),
//                     Text("Payment Successfull"),
//                   ],
//                 ),
//               ));
//       paymentIntent = null;
//     }).onError((error, stackTrace) {
//       print('Error is:---> $error $stackTrace');
//     });
//   } on StripeException catch (e) {
//     print('Error is---> $e');
//     showDialog(
//         context: context,
//         builder: (_) => const AlertDialog(
//               content: Text("Cancelled"),
//             ));
//   } catch (e) {
//     print('$e');
//   }
// }
//
// createPaymentIntent(String amount, String currency) async {
//   try {
//     Map<String, dynamic> body = {
//       'amount': calculateAmount(amount),
//       'currency': currency,
//       'payment_method_types[]': 'card',
//     };
//     var response = await http.post(
//       Uri.parse('http://api.stripe.com/v1/payment_intents'),
//       headers: {
//         'Authorization': 'Bearer $secretKey',
//         'Content_Type': 'application/x-www-form-urlencoded'
//       },
//       body: body,
//     );
//     print('Payment Intent Body->>> ${response.body.toString()}');
//     return jsonDecode(response.body);
//   } catch (err) {
//     print('err charging user: ${err.toString()}');
//   }
// }
//
// calculateAmount(String amount) {
//   final calculateAmount = (int.parse(amount) * 100);
//   return calculateAmount.toString();
// }
}
