import 'dart:io';

import 'package:app/service/database.dart';
import 'package:app/widget/widget_support.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddVeges extends StatefulWidget {
  const AddVeges({Key? key}) : super(key: key);

  @override
  State<AddVeges> createState() => _AddVegesState();
}

class _AddVegesState extends State<AddVeges> {
  final List<String> vegesitems = ['Vegetables'];
  String? categoryValue;
  String? quantityValue;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool uploading = false;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text.isNotEmpty &&
        pricecontroller.text.isNotEmpty &&
        detailcontroller.text.isNotEmpty &&
        categoryValue != null &&
        quantityValue != null) {
      setState(() {
        uploading = true;
      });

      try {
        String addId = randomAlphaNumeric(10);

        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("blogImages").child(addId);
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

        var snapshot = await task.whenComplete(() => null);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        Map<String, dynamic> addItem = {
          "Image": downloadUrl,
          "Name": namecontroller.text,
          "Price": pricecontroller.text,
          "Detail": detailcontroller.text,
          "Category": categoryValue,
          "Quantity": quantityValue,
          "isAvailable": '',
        };

        await DatabaseMethods().addVeges(addItem, categoryValue!);

        // Show alert dialog after adding the item
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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
                "Vegetable added successfully!",
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
            );
          },
        );
      } catch (e) {
        print("Error uploading item: $e");
      } finally {
        setState(() {
          uploading = false;
        });

        // Clear fields after successful upload
        clearFields();
      }
    } else {
      // Handle case where not all fields are filled
      print("Please fill all fields");
    }
  }

  void clearFields() {
    selectedImage = null;
    namecontroller.clear();
    pricecontroller.clear();
    detailcontroller.clear();
    categoryValue = null;
    quantityValue = null;
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
          "Add Item",
          style: AppWidget.HeadlineTextFieldStyle(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: 50.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload the Item Picture",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  SizedBox(height: 20.0),
                  selectedImage == null
                      ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 30.0),
                  Text(
                    "Item Name",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Item Name",
                        hintStyle: AppWidget.LightTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Item Price",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: pricecontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Item Price",
                        hintStyle: AppWidget.LightTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Select Quantity",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: ['kg', 'piece', 'bunch']
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: ((value) => setState(() {
                              quantityValue = value;
                            })),
                        dropdownColor: Colors.white,
                        hint: Text("Select Quantity"),
                        iconSize: 36,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        value: quantityValue,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Item Detail",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      maxLines: 6,
                      controller: detailcontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Item Detail",
                        hintStyle: AppWidget.LightTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Select Category",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: vegesitems
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: ((value) => setState(() {
                              categoryValue = value;
                            })),
                        dropdownColor: Colors.white,
                        hint: Text("Select Category"),
                        iconSize: 36,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        value: categoryValue,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      uploadItem();
                    },
                    child: Center(
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (uploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
