import 'package:app/service/database.dart';
import 'package:app/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageStock extends StatefulWidget {
  const ManageStock({super.key});

  @override
  State<ManageStock> createState() => _ManageStockState();
}

class _ManageStockState extends State<ManageStock> {
  Stream? VegesStream;
  DocumentSnapshot? selectedVegetable;

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
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data.docs.isEmpty) {
          return Center(child: Text('No vegetables found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              var data = ds.data() as Map<String, dynamic>?;
              bool isAvailable = data != null && data.containsKey('isAvailable')
                  ? data['isAvailable']
                  : true;
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    selectedVegetable = ds;
                  });
                },
                child: Container(
                  color: selectedVegetable?.id == ds.id ? Colors.grey[300] : Colors.white,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
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
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    ds["Name"],
                                    style: AppWidget.boldTextFieldStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  child: Text(
                                    "Fresh",
                                    style: AppWidget.LightTextFieldStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  child: Text(
                                    "\u{20B9}${ds["Price"]}/${ds["Quantity"]}",
                                    style: AppWidget.boldTextFieldStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void markAsOutOfStock() async {
    if (selectedVegetable != null) {
      await FirebaseFirestore.instance
          .collection('Vegetables')
          .doc(selectedVegetable!.id)
          .update({'isAvailable': false});
      getontheload(); // Refresh UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vegetable marked as out of stock successfully!'),
        ),
      );
    }
  }

  void markAsAvailable() async {
    if (selectedVegetable != null) {
      await FirebaseFirestore.instance
          .collection('Vegetables')
          .doc(selectedVegetable!.id)
          .update({'isAvailable': true});
      getontheload(); // Refresh UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vegetable marked as available successfully!'),
        ),
      );
    }
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
          ),
        ),
        centerTitle: true,
        title: Text(
          "Manage Stock",
          style: AppWidget.HeadlineTextFieldStyle(),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: allVegesDetails()),
          if (selectedVegetable != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: markAsOutOfStock,
                      child: Text("Out of Stock"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: markAsAvailable,
                      child: Text("Available"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
