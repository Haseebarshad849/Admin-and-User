import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String email;
  String name;
  String password;

  bool isAdmin;
  String uid;

  Person({
    this.email,
    this.isAdmin,
    this.name,
    this.password,
    this.uid,
  });

  factory Person.fromFirestore(DocumentSnapshot document) {
    Map data = document.data();

    return Person(
        email: data['email'] as String,
        name: data['name'] as String,
        password: data['password'] as String,
        isAdmin: data['isAdmin'] as bool,
        uid: data['uid'] as String);
  }
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'isAdmin': isAdmin,
      'uid': uid,
      'password': password
    };
  }
}
