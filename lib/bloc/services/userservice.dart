import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

//create user
Future createUser({
  required String username,
  required String fullname,
  required int contact,
  required String email,
}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  final json = {
    'username': username,
    'fullname': fullname,
    'contact': contact,
    'email': email,
  };

  await docUser.set(json);
}

//update user
Future<void> updateUser({
  String? id,
  String? email,
  String? username,
  String? fullname,
  int? contact,
  String? password,
}) async {
  final docUser = FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email);

  final dataToUpdate = <String, dynamic>{};

  if (username != null && username.isNotEmpty) {
    dataToUpdate['username'] = username;
  }

  if (fullname != null && fullname.isNotEmpty) {
    dataToUpdate['fullname'] = fullname;
  }

  if (contact != null && contact > 0) {
    dataToUpdate['contact'] = contact;
  }

  if (password != null && password.isNotEmpty) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.uid == id) {
      await currentUser?.updatePassword(password);
    }
  }

  //retreive the first matching document and then update it with new data
  await docUser.get().then((querySnapshot) async {
    final documentSnapshot = querySnapshot.docs.first;
    await documentSnapshot.reference.update(dataToUpdate);
  });
}

//admin update user
Future<void> adminupdateUser({
  String? id,
  String? email,
  String? username,
  String? fullname,
  int? contact,
}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(id);

  final dataToUpdate = <String, dynamic>{};

  if (username != null && username.isNotEmpty) {
    dataToUpdate['username'] = username;
  }

  if (fullname != null && fullname.isNotEmpty) {
    dataToUpdate['fullname'] = fullname;
  }

  if (contact != null && contact > 0) {
    dataToUpdate['contact'] = contact;
  }

  //retreive the first matching document and then update it with new data
  // Update the document with new data
  await docUser.update(dataToUpdate);
}

//delete user
Future<void> deleteUser(String? id) async {
  try {
    //delete desired user data from authentication based on id
    // await FirebaseAuth.instance.currentUser?.delete();

    // Delete user document from Firestore
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.delete();

    // Additional cleanup or handling after successful deletion
  } catch (e) {
    // Handle any errors that occur during deletion
    if (kDebugMode) {
      print('Error deleting user: $e');
    }
  }
}
