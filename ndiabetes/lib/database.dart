import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

class Database {

  static Future<void> addUser(String uid, String firstName, String lastName,
      String email, String password, int age, String gender,
      double weight, double height, String diseaseType) async {
    // Call the user's CollectionReference to add a new user
    users.doc(uid).set({
      'firstName': firstName, // John Doe
      'lastName': lastName, // Stokes and Sons
      'email': email,
      'password' : password,
      'age': age,
      'gender' : gender,
      'weight' : weight,
      'height' : height,
      'diseaseType' : diseaseType// 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }







}