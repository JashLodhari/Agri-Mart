import 'package:app/pages/details.dart';
import 'package:app/service/database.dart';
import 'package:app/service/shared_pref.dart';
import 'package:app/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

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

  Widget shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: Duration(seconds: 2), // Duration of the shimmer effect
      child: ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: 5, // Number of shimmer items
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
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
                      child: Container(
                        color: Colors.white,
                        height: 120,
                        width: 120,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: vegesitemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return shimmerEffect();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data.docs.isEmpty) {
          return Center(child: Text('No vegetables found'));
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(5.0),
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              var data = ds.data() as Map<String, dynamic>?;
              bool isAvailable = data != null && data.containsKey('isAvailable') ? data['isAvailable'] : true;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        detail: ds["Detail"],
                        name: ds["Name"],
                        price: ds["Price"],
                        image: ds["Image"],
                        quantity: ds["Quantity"],
                        isAvailable: isAvailable, // Pass isAvailable to Details widget
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.0),
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
                            child: Image.network(
                              ds["Image"],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Text(
                                  ds["Name"],
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Text(
                                  "Fresh",
                                  style: AppWidget.LightTextFieldStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Text(
                                  "\u{20B9}${ds["Price"]}/${ds["Quantity"]}",
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              if (!isAvailable)
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    "Out of Stock",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? Center(
        child: shimmerEffect(), // Show shimmer effect while loading name
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey! ${name!}",
                  style: AppWidget.boldTextFieldStyle(),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Fresh Vegetables",
                  style: AppWidget.HeadlineTextFieldStyle(),
                ),
                Text(
                  "Discover and Get Great Veges",
                  style: AppWidget.LightTextFieldStyle(),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: allItemsVertically(),
            ),
          ),
        ],
      ),
    );
  }
}
