import 'package:app/pages/bottom_navigation.dart';
import 'package:app/pages/login.dart';
import 'package:app/service/database.dart';
import 'package:app/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../widget/widget_support.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = "", email = "", password = "", depLoc = "", buildingName = "", mobileNo = "";

  bool loading = false;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController depLoccontroller = TextEditingController();
  TextEditingController buildingNamecontroller = TextEditingController();
  TextEditingController mobileNocontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Registration Successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        )));
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          "Id": Id,
          "Name": namecontroller.text,
          "Email": emailcontroller.text,
          "Department Location": depLoccontroller.text,
          "Building Name": buildingNamecontroller.text,
          "Mobile Number": mobileNocontroller.text,
          "Wallet": "0",
        };
        await DatabaseMethods().addUserDetail(addUserInfo, Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(emailcontroller.text);
        await SharedPreferenceHelper().saveUserDepLoc(depLoccontroller.text);
        await SharedPreferenceHelper().saveUserBuildingName(buildingNamecontroller.text);
        await SharedPreferenceHelper().saveUserMobile(mobileNocontroller.text);
        await SharedPreferenceHelper().saveUserWallet('0');
        await SharedPreferenceHelper().saveUserId(Id);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password provided is too weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account already exits",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFff5c30), Color(0xFFe74b1a)])),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Text(""),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Center(
                            child: Image.asset(
                              "images/filename (1).png",
                              width: MediaQuery.of(context).size.width / 1,
                              fit: BoxFit.cover,
                            )),
                        SizedBox(height: 50.0),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  SizedBox(height: 30.0),
                                  Text(
                                    "Sign up",
                                    style: AppWidget.HeadlineTextFieldStyle(),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: namecontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Name',
                                        hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.person_outlined)),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: emailcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.email_outlined)),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: passwordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Password';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.password_outlined)),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: depLoccontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Department_Location';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Department Location',
                                        hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.location_city_outlined)),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: buildingNamecontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Building Name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Building Name',
                                        hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.location_city_sharp)),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: mobileNocontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Mobile No.';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        hintText: 'Mobile No.',
                                        hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.phone_android_outlined)),
                                  ),
                                  SizedBox(height: 60.0),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        setState(() {
                                          name = namecontroller.text;
                                          email = emailcontroller.text;
                                          password = passwordcontroller.text;
                                          depLoc = depLoccontroller.text;
                                          buildingName = buildingNamecontroller.text;
                                          mobileNo = mobileNocontroller.text;
                                        });
                                        await registration();
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    },
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                        width: 200,
                                        decoration: BoxDecoration(
                                            color: Color(0Xffff5722),
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Center(
                                          child: Text(
                                            "SIGN UP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontFamily: 'Poppins1',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 70.0),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
                            },
                            child: Text(
                              "Already have an account? Login",
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 200,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text("Loading...", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
