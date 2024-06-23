import 'package:app/pages/bottom_navigation.dart';
import 'package:app/pages/forgot_password.dart';
import 'package:app/pages/signup.dart';
import 'package:app/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  bool loading = false;

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  userLogin() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No User Found for that Email", style: TextStyle(fontSize: 18.0, color: Colors.black),),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wrong Password Provided by User", style: TextStyle(fontSize: 18.0, color: Colors.black),),
        ));
      }
    } finally {
      setState(() {
        loading = false;
      });
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
                        colors: [Color(0xFFff5c30), Color(0xFFe74b1a)],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Text(""),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Center(
                          child: Image.asset(
                            "images/filename.png",
                            width: MediaQuery.of(context).size.width / 1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  SizedBox(height: 30.0),
                                  Text(
                                    "Login",
                                    style: AppWidget.HeadlineTextFieldStyle(),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: useremailcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: userpasswordcontroller,
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
                                      prefixIcon: Icon(Icons.password_outlined),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Forgot Password?",
                                        style: AppWidget.semiBoldTextFieldStyle(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 100.0),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          email = useremailcontroller.text;
                                          password = userpasswordcontroller.text;
                                        });
                                        await userLogin();
                                      }
                                    },
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Color(0Xffff5722),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "LOGIN",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontFamily: 'Poppins1',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Don't have an account? Sign up",
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      Text("Logging In...", style: TextStyle(fontSize: 18)),
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
