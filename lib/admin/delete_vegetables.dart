import 'package:app/service/database.dart';
import 'package:app/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteVeges extends StatefulWidget {
  const DeleteVeges({super.key});

  @override
  State<DeleteVeges> createState() => _DeleteVegesState();
}

class _DeleteVegesState extends State<DeleteVeges> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController quantitycontroller = new TextEditingController();
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
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ds["Name"],
                                          style: AppWidget.boldTextFieldStyle(),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await DatabaseMethods().deleteVeges(ds["id"]);
                                          },
                                          child: Flexible(
                                              child: Icon(
                                            Icons.delete,
                                            color: Colors.orange,
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: Text(
                                      "Fresh",
                                      style: AppWidget.LightTextFieldStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: Text(
                                      "\u{20B9}" + ds["Price"] + "/kg",
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
          "Delete Item",
          style: AppWidget.HeadlineTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allVegesDetails()),
          ],
        ),
      ),
    );
  }

  Future EditVegesDetails(String id) => showDialog(
      context: context,
      builder: (context) => (AlertDialog(
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(width: 60.0),
                      Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Details",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: namecontroller,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Price",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: pricecontroller,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> updateInfo = {
                              "Name": namecontroller.text,
                              "Id": id,
                              "Price": pricecontroller.text
                            };
                            await DatabaseMethods()
                                .updateVeges(id, updateInfo)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Update")))
                ],
              ),
            ),
          )));
}
