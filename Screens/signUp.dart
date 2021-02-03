import 'package:admin_and_user_side/Screens/logIn.dart';
import 'package:admin_and_user_side/Screens/mainHomeScreen.dart';
import 'package:admin_and_user_side/Services/authServices.dart';
import 'package:admin_and_user_side/Services/cloudStore.dart';
import 'package:admin_and_user_side/model/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //String name, email, pass;
  final auth = FirebaseAuth.instance;
  var _formkey = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.cyan[900],
          title: Text("Create An Account"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // =================
                  // ====Name fild=====
                  // ==================
                  TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      nameCon.text = value;
                    },
                    controller: nameCon,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Name',
                        errorStyle: TextStyle(
                          color: Colors.red[900],
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Enter Your Full Name'),
                  ),
                  // For Spacing
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  // =================
                  // ====email fild=====
                  // ==============
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailCon,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    // ignore: missing_return
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
                    onSaved: (value) {
                      emailCon.text = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(Icons.email_outlined),
                        errorStyle: TextStyle(
                          color: Colors.red[900],
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'someone@email.com'),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  // =================
                  // ====pasword fild=====
                  // ==============

                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: passCon,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter new password';
                      } else if (value.length < 6) {
                        return 'The Password must contain atleast 6 characters';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      passCon.text = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(Icons.lock),
                        errorStyle: TextStyle(
                          color: Colors.red[900],
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Password'),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),

                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      color: Colors.cyan[700],
                      textColor: Colors.white,
                      splashColor: Colors.redAccent,
                      elevation: 2.0,
                      onPressed: () async {
                        dynamic result = '';
                        //if (emailController.text.trim() != null) {
                        if (_formkey.currentState.validate()) {
                          _formkey.currentState.save();
                          result = await AuthService()
                              .registerAccountWithEmailPassword(
                                  emailCon.text, passCon.text);

                          if (auth.currentUser == null) {
                            print('Error Creating Account');
                            print(result);
                            _scaffoldkey.currentState.showSnackBar(
                                new SnackBar(content: new Text(result)));
                          } else {
                            print('Signed In Successfull');
                            String uid = auth.currentUser.uid;
                            bool isAdmin = false;
                            //result = uid;
                            var u = Person(
                                email: emailCon.text,
                                password: passCon.text,
                                name: nameCon.text,
                                isAdmin: isAdmin,
                                uid: uid);

                            await CloudStore().addUser(u);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainHomeScreen(),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Already have an account",
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
                                  builder: (context) => LogIn(),
                                ));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.blue[400]),
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
        ),
      ),
    );
  }
}
