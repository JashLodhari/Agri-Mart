import 'dart:io';
import 'package:app/admin/admin_login.dart';
import 'package:app/admin/home_admin.dart';
import 'package:app/pages/bottom_navigation.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA1dHAdcER1GH1AXHpv2M2TrcWQxNBLmHQ",
        appId: "1:427405783097:android:8aed9924d19d94bc111de8",
        messagingSenderId: "427405783097",
        projectId: "agri-mart-app-46881",
        storageBucket: "agri-mart-app-46881.appspot.com",
      ))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeAdmin(),
    );
  }
}