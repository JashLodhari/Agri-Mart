import 'package:app/service/database.dart';
import 'package:app/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetriveVeges extends StatefulWidget {
  const RetriveVeges({super.key});

  @override
  State<RetriveVeges> createState() => _RetriveVegesState();
}

class _RetriveVegesState extends State<RetriveVeges> {
  Stream? VegesStream;

  getontheload() async {
    VegesStream = await DatabaseMethods().retriveVeges();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allVegesDetails() {
    return StreamBuilder(
        stream: VegesStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      padding: EdgeInsets.only(left: 10.0),
                      margin: EdgeInsets.only(right: 10.0, bottom: 20.0),
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
                                    height: 100, width: 100, fit: BoxFit.cover),
                              ),
                              SizedBox(width: 20.0),
                              Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                      ds["Name"],
                                      style: AppWidget.boldTextFieldStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                      "Fresh",
                                      style: AppWidget.LightTextFieldStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                      "\u{20B9}${ds["Price"]}/${ds["Quantity"]}",
                                      style: AppWidget.boldTextFieldStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF373866),
            )),
        centerTitle: true,
        title: Text(
          "Retrive Item",
          style: AppWidget.HeadlineTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Column(
          children: [
            Expanded(child: allVegesDetails()),
          ],
        ),
      ),
    );
  }
}
