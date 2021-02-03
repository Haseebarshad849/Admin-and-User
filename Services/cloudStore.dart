import 'package:admin_and_user_side/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudStore {
  // Create a CollectionReference called users that references the firestore collection
  final users = FirebaseFirestore.instance.collection('users');
  //users = users.orderBy('name');

  Future<void> addUser(Person p) {
    // Call the user's CollectionReference to add a new user
    return users.doc(p.uid).set(p.toFirestore());
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await users.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data());
        });
      });

      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
