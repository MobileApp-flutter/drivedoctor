import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//create user
Future createUser({
  required String username,
  required String fullname,
  required int contact,
  required String email,
  required String password,
}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  final json = {
    'username': username,
    'fullname': fullname,
    'contact': contact,
    'email': email,
    'password': password,
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
    dataToUpdate['password'] = password;

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
