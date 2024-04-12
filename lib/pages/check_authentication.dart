import 'package:app/pages/home.dart';
import 'package:app/pages/onboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthentication extends StatelessWidget {
  const CheckAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return const Home();
            }else{
              return const Onboard();
            }
          }),
    );
  }
}