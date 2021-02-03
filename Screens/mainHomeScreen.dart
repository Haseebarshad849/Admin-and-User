import 'dart:io';

import 'package:admin_and_user_side/Services/authServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'logIn.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  //bool isEnabled = false;
  bool isAdmin;
  File _image;
  CollectionReference imgRef;
  firebase_storage.Reference ref;

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
    get();
  }

  get() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) {
        Map m = value.data();
        setState(() {
          isAdmin = m['isAdmin'];
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  imageContainer() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.4,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("imageURLs").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Error getting data");
          } else if (snapshot.data == null) return CircularProgressIndicator();
          return ListView(
            children: snapshot.data.docs.map((document) {
              var url = document['url'];
              print(url);
              return Container(child: Image.network(url));
            }).toList(),
          );
        },
      ),
    );
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
      uploadPic(this.context);
    });
  }

  Future uploadPic(BuildContext context) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}');
    await ref.putFile(_image).whenComplete(
      () {
        ref.getDownloadURL().then(
          (value) {
            imgRef.add({'url': value});
            print('Image URL Store successfully');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
        backgroundColor: Colors.cyan[600],
        actions: [
          RaisedButton(
              onPressed: () {
                AuthService().signOut().whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogIn(),
                    ),
                  );
                });
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              color: Colors.cyan)
        ],
      ),
      body: (isAdmin == false)
          ? imageContainer()
          : ListView(
              children: [
                imageContainer(),
                // Storage().listImages,
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: RaisedButton(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Upload Picture',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.deepOrange[800],
                      onPressed: () {
                        getImage();
                      }),
                ),
              ],
            ),
    );
  }
}
