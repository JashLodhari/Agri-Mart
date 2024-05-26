import 'package:app/pages/details.dart';
import 'package:app/pages/order.dart';
import 'package:app/service/database.dart';
import 'package:app/service/shared_pref.dart';
import 'package:app/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? vegesitemStream;
  String? name;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  ontheload() async {
    vegesitemStream = await DatabaseMethods().getVeges("Vegetables");
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    ontheload();
    super.initState();
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: vegesitemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            padding: EdgeInsets.all(5.0),
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Details(
                                detail: ds["Detail"],
                                name: ds["Name"],
                                price: ds["Price"],
                                image: ds["Image"],
                              )));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(ds["Image"],
                                height: 120, width: 120, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            children: [
                              Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                child: Text(
                                  ds["Name"],
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                child: Text(
                                  "Fresh",
                                  style: AppWidget.LightTextFieldStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                child: Text(
                                  "\u{20B9}" + ds["Price"] + "/Kg",
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
            : CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? CircularProgressIndicator()
          : SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello, ${name!}", style: AppWidget.boldTextFieldStyle()),
                ],
              ),
              SizedBox(height: 20.0),
              Text("Fresh Vegetables",
                  style: AppWidget.HeadlineTextFieldStyle()),
              Text("Discover and Get Great Veges",
                  style: AppWidget.LightTextFieldStyle()),
              SizedBox(height: 30.0),
              Column(
                children: [
                  Container(child: allItemsVertically()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
