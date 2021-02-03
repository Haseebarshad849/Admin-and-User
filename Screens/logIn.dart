import 'package:admin_and_user_side/Screens/mainHomeScreen.dart';
import 'package:admin_and_user_side/Screens/signUp.dart';
import 'package:admin_and_user_side/Services/authServices.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // =======================
  // =====Declaration=======
  // =======================
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _obscureText = true;
  String email, password, name, error;
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  User user;
  var _formkey = GlobalKey<FormState>();
  bool autoValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text('Login Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              // showAlert(),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                controller: usercontroller,
                // ignore: deprecated_member_use
                autovalidate: autoValidate,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return 'Please a valid Email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black),
                    errorStyle: TextStyle(
                      color: Colors.red[900],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: 'someone@example.com'),
                // maxLength: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                controller: passcontroller,
                // ignore: deprecated_member_use
                autovalidate: autoValidate,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Invalid Password';
                  } else if (value.length < 6) {
                    return 'Incorrect Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value.trim();
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorStyle: TextStyle(
                      color: Colors.red[900],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: '**********'),
                obscureText: _obscureText,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              SizedBox(
                // width: 20.0,
                height: 50.0,
                child: RaisedButton(
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: Colors.cyan[700],
                    textColor: Colors.white,
                    splashColor: Colors.black,
                    elevation: 2.0,
                    onPressed: () async {
                      dynamic result = '';
                      if (_formkey.currentState.validate()) {
                        _formkey.currentState.save();
                        result = await AuthService()
                            .signInWithEmailPassword(email, password);
                        if (auth.currentUser == null) {
                          print('Error Signing In');
                          print(result);
                          _scaffoldkey.currentState.showSnackBar(
                              new SnackBar(content: new Text(result)));
                        } else {
                          print('Signed In Successfull');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainHomeScreen(),
                              ));
                        }
                      }
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Dont have an account",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ));
                      },
                      child: Text(
                        'Sign Up',
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.blue[400]),
                      ),
                      splashColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
