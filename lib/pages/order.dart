import 'dart:async';

import 'package:app/service/database.dart';
import 'package:app/service/shared_pref.dart';
import 'package:app/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0;

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    vegesStream = await DatabaseMethods().getVegesCart(id ?? "null");
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  Stream? vegesStream;

  void removeItemFromCart(String docId) async {
    await DatabaseMethods().removeItemFromCart(id ?? "null", docId);
    ontheload(); // Refresh the cart after removing an item
  }

  void calculateTotal(AsyncSnapshot snapshot) {
    total = 0;
    for (var doc in snapshot.data.docs) {
      total += int.parse(doc["Total"]);
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Are you sure you want to delete this item from your cart?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                removeItemFromCart(docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget vegesCart() {
    return StreamBuilder(
      stream: vegesStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          calculateTotal(snapshot);
          return ListView.builder(
            padding: EdgeInsets.all(5.0),
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: Text(ds["Quantity"])),
                            ),
                            SizedBox(width: 20.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                ds["Image"],
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds["Name"],
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                                Text(
                                  "\u{20B9}" + ds["Total"],
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDeleteConfirmationDialog(context, ds.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    "Veges Cart",
                    style: AppWidget.HeadlineTextFieldStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded( // Use Expanded to make the list view take available space
              child: vegesCart(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  Text(
                    "\u{20B9}" + total.toString(),
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                int amount = int.parse(wallet!) - total;
                await DatabaseMethods().UpdateUserwallet(id!, amount.toString());
                await SharedPreferenceHelper().saveUserWallet(amount.toString());
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "CheckOut",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
