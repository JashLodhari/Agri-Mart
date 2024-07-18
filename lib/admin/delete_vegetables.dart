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
              String docId = ds.id; // Accessing the document ID directly
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
                              width: MediaQuery.of(context).size.width / 2.3,
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
                                      // Show confirmation dialog
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Confirm Deletion"),
                                          content: Text(
                                              "Are you sure you want to delete this item?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmDelete) {
                                        // If user confirms, delete the item
                                        await DatabaseMethods()
                                            .deleteVeges(docId)
                                            .then((value) {
                                          // Show success dialog
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              title: Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.green),
                                                  SizedBox(width: 10),
                                                  Text("Success"),
                                                ],
                                              ),
                                              content: Text(
                                                "Vegetable has been deleted successfully!",
                                                style: TextStyle(fontSize: 18.0),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      }
                                    },
                                    child: Flexible(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: Text(
                                "Fresh",
                                style: AppWidget.LightTextFieldStyle(),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.3,
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
      },
    );
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
