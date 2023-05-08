import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Stream<UserData?> get userDataStream {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    return userDoc.snapshots().map(
        (snapshot) => snapshot.exists ? UserData.fromSnapshot(snapshot) : null);
  }
}
