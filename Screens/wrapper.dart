import 'package:admin_and_user_side/Screens/logIn.dart';
import 'package:admin_and_user_side/Screens/mainHomeScreen.dart';
import 'package:admin_and_user_side/Services/authServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: deprecated_member_use
      home: StreamBuilder<User>(
        stream: AuthService().auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainHomeScreen();
          } else {
            return LogIn();
          }
        },
      ),
    );
  }
}
